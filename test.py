import sys
print(sys.version_info)
def testDocs(a: str, b: str) -> str:
    '''    tis awesome
    Keyword arguments:
        a: whatever
        b: whatever 2
    '''
    return 'wibble'
print(testDocs(None, None))
testDocs()
