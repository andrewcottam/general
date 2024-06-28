import rasterio, numpy
from rasterio.features import sieve

def write_to_file(src: rasterio.DatasetReader, filename: str, array: numpy.ndarray):
    """Writes a rasterio dataset to file using the same profile as the source dataset

    Args:
        src (rasterio.DatasetReader): The source rasterio dataset
        filename (str): The filename to write the raster to
        array (numpy.ndarray): The array of data to write 
    """
    # Register GDAL format drivers and configuration options with a context manager.
    with rasterio.Env():
        # Write an array as a raster band to a new 8-bit file. For the new file's profile, we start with the profile of the source
        profile = src.profile
        # Update the nodata value to 0
        profile.update({"nodata": 0})
        # And then change the band count to 1, set the dtype to uint8, and specify LZW compression.
        profile.update(dtype=rasterio.uint8, count=1, compress='lzw')
        with rasterio.open(filename, 'w', **profile) as dst:
            dst.write(array.astype(rasterio.uint8), 1)
        # At the end of the ``with rasterio.Env()`` block, context manager exits and all drivers are de-registered.

def filter_data(input_file: str, output_file: str, forest_threshold: int, patch_size_threshold: float):
    """Filters the passed data using the various thresholds

    Args:
        input_file (str): The full path to the file - either a gsutil uri or a filename, e.g. gs://overstory-public/RA/Cameroon/cameroon_v3_forestmap.tif or ./data/cameroon_v3_forestmap.tif
        output_file (str): The full output filename, e.g. /Users/andrewcottam/Documents/GitHub/deep-learning/overstory/data/cameroon_v3_forestmap_clipped_filtered.tif
        forest_threshold (int): The percentage threshold for splitting forest/non-forest
        patch_size_threshold (float): Patches of forest smaller than this threshold will be filtered out from the final output (in Hectares, e.g. 0.5)
    """
    with rasterio.open(input_file) as src:
        print(f"Processing: {input_file}")
        # Convert the patch size threshold into metres squared
        size_threshsold = patch_size_threshold * 10000
        # Get the source resolution in m
        resolution = src.res[0]
        # Hack for Nigeria which reports the resolution as 0
        resolution = 10
        if (int(resolution)!=0):    
            # Calculate the sieve threshold in pixels
            sieve_threshold = int(size_threshsold / (resolution ** 2))
            print(f"Forest threshold: {forest_threshold} %")        
            print(f"Size threshold: {str(patch_size_threshold)} m2")
            print(f"Resolution: {int(resolution)} m")
            print(f"Sieve threshold: {sieve_threshold} pixels")
            # Convert the data to uint8 (0-255 - nodata values are 255)
            input_data = src.read().astype(rasterio.uint8)
            # Reclassify the data to forest/non-forest using a threshold of 50%
            input_data = numpy.where(numpy.logical_and(input_data > forest_threshold, input_data != 255), 1, 0).astype(rasterio.uint8)
            # Sieve the data with a size of 10 pixels
            output_data = sieve(input_data, sieve_threshold)
            # Multiply the sieved data by the input data so we re-mask holes that have been filled in by sieve
            output_data = input_data[0] * output_data
            # Write the data out to disk
            write_to_file(src, output_file, output_data)
        else:
            print("The resolution is 0m!!")

def get_metadata(filename: str)->dict:
    """Gets the metadata for the passed rasterio dataset

    Args:
        filename (str): The filename to the raster dataset

    Returns:
        dict: The metadata as a dictionary
    """
    with rasterio.open(filename) as src:
        return src.meta
    
# Get the metadata
# print(get_metadata(filename))

# Filter the dataset
# filter_data('./data/cameroon_v3_forestmap.tif', './data/cameroon_v3_forestmap_filtered.tif', 51, 0.5)
# filter_data('./data/honduras_forestmap_v2.tif', './data/honduras_forestmap_v2_filtered.tif', 50, 0.5)
# filter_data('./data/forestmap_indonesia_1.tif', './data/forestmap_indonesia_1_filtered.tif', 50, 0.5)
filter_data('./data/forestmap_indonesia_2.tif', './data/forestmap_indonesia_2_filtered.tif', 50, 0.5)
# filter_data('./data/nicaragua_v2.tif', './data/1_forestmap_filtered.tif', 50, 0.5)
# filter_data('./data/nigeria_v2_forestmap.tif', './data/nigeria_v2_forestmap_filtered.tif', 51, 0.5)
filter_data('./data/ic_forest_v2.tif', './data/ic_forest_v2_filtered.tif', 50, 0.5)

# Copying the files from Google Cloud Storage to gfs using gsutil - run from the '/home/jovyan/gfs/andrew_cottam/rainforest alliance/data' folder
# gsutil cp gs://overstory-public/RA/Cameroon/cameroon_v3_forestmap.tif .
# gsutil cp gs://overstory-public/RA/Cameroon/honduras_forestmap_v2.tif .
# gsutil cp gs://overstory-public/RA/Indonesia_all/forestmap_indonesia.tif .
# gsutil cp gs://overstory-public/RA/nicaragua_v2.1_forestmap.tif .
# gsutil cp gs://overstory-public/RA/Nigeria/nigeria_v2_forestmap.tif .
# gsutil cp gs://overstory-customer-ra/customer-data/ic_forest_v2.zip .

# Copy the final filtered datasets back to Google Cloud Storage
# gsutil cp "/home/jovyan/gfs/andrew_cottam/rainforest alliance/data/cameroon_v3_forestmap_filtered_05ha.tif" gs://overstory-public/RA/Cameroon/Cameroon_v3_forestmap_filtered_05ha.tif
# gsutil cp "/home/jovyan/gfs/andrew_cottam/rainforest alliance/data/honduras_forestmap_v2_filtered.tif" gs://overstory-public/RA/honduras_forestmap_v2_filtered_05ha.tif
# gsutil cp "/home/jovyan/gfs/andrew_cottam/rainforest alliance/data/forestmap_indonesia_1_filtered.tif" gs://overstory-public/RA/Indonesia_all/forestmap_indonesia_1_filtered_05ha.tif
# gsutil cp "/home/jovyan/gfs/andrew_cottam/rainforest alliance/data/forestmap_indonesia_2_filtered.tif" gs://overstory-public/RA/Indonesia_all/forestmap_indonesia_2_filtered_05ha.tif
# gsutil cp "/home/jovyan/gfs/andrew_cottam/rainforest alliance/data/nicaragua_v2.1_forestmap_filtered.tif" gs://overstory-public/RA/nicaragua_v2.1_forestmap_filtered_05ha.tif
# gsutil cp "/home/jovyan/gfs/andrew_cottam/rainforest alliance/data/nigeria_v2_forestmap_filtered.tif" gs://overstory-public/RA/Nigeria/nigeria_v2_forestmap_filtered_05ha.tif