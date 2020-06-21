# Marxan Web Project Plan
## Executive Summary
The Joint Research Centre (JRC) through the BIOPAMA project are supporting the development and roll-out of a decision support tool called Marxan Web which can support the designation of new protected areas based on a robust scientific method. This project plan describes in detail the background, current status, vision and workplan for the Marxan Web tool including how the tool will be deployed and used within the BIOPAMA regions and what impact it can hope to achieve.

## Background
One of the main aims of the JRC BIOPAMA project is to improvement management effectiveness and governance of protected areas in the Africa, Caribbean and Pacific (ACP) regions. In support of this objective, JRC have invested in the development of analyses, tools and services that provide reference information on existing protected areas and help to improve their conservation status. In addition to these existing protected area networks, JRC are also supporting the development of tools to extend these networks to help meet the Convention of Biological Diversity (CBD) Aichi Target 11:

'By 2020, at least 17 per cent of terrestrial and inland water, and 10 per cent of coastal and marine areas, especially areas of particular importance for biodiversity and ecosystem services, are conserved through effectively and equitably managed, ecologically representative and well connected systems of protected areas and other effective area-based conservation measures, and integrated into the wider landscapes and seascapes.'

Many countries of the ACP region have taken this CBD target and adapted it into their own National Biodiversity Strategy and Action Plan (NBSAP). These documents are a key delivery mechanism of the CBD. Within the text of the national targets are clear statements on how much of the countries terrestrial and marine areas should be within protected areas and how to achieve ecological representivity within that network. Ecological representivity is a measure of how much of the overall flora and fauna of a country is represented and may be expressed as targets for individual species, habitats or ecosystem services. Unfortunately, gaps remain in meeting these representation targets for many countries (Gannon et al., 2017). Taking Australia as an example, within their Marine protected area network there are large discrepancies between what proportion of each marine habitat is protected from 85% for abyssal plains (mainly species-poor bare rock) to habitats which have no protection at all (including basin, sill, ridge and trench/trough habitats).

In order to support countries in meeting their areal and representation targets, there are a number of software tools that are available that incorporate robust scientific and mathematical algorithms - called Systematic Conservation Planning (SCP) tools. These tools have been used for many applications in decision support, not just in conservation but in other areas where land-use planning is a consideration. The most widely used of these tools is a piece of software called Marxan and this was originally developed by the University of Queensland in Australia over 20 years ago. Over the years it has been used for many conservation applications including many national level designation processes, regional strategies and local scale spatial planning applications. It is estimated that there are over 1000 regular users of Marxan globally (Janßen et al., 2019) and there are over 4,000 citations on Google Scholar.

Marxan has continued developing over the years through grants and donations from a wide variety of organisations and this support has been used to develop a whole ecosystem of related tools, plugins and apps that extend the core features of the software. However, at its core, it is essentially the same DOS software that was in use over 20 years ago. While there is now a plugin for Quantum GIS (QGIS) called CLUZ that provides a map interface to Marxan, it is still a specialist tool for GIS staff and consultants.

In late 2018 JRC met with The Nature Conservancy (TNC) - a global scale conservation NGO which coordinates the activities related to Marxan. One of their main ambitions is to make the SCP much more accessible to a broader community, including non-technical users such as government departments, in what they call the 'Marxan Revolution'. The aim would be to embed scientifically robust methods within the decision-making of national governments in relation to protected area networks. This aim is one that JRC share through the BIOPAMA project and so JRC agreed to support the project through in-kind contribution through the development of the Marxan software. In addition, the BIOPAMA network through the regional IUCN partners will be instrumental in rolling out this capacity to the ACP regions.

This project plan is the result of the discussions between TNC and JRC on the future of SCP tools and Marxan in particular and on how to enable SCP as widely as possible to support better conservation decisions.

## Current Status
The Marxan software is currently widely used within the academic and scientific communities but has limited reach outside of these traditional sectors. The tool is based in DOS and requires a high level of technical skills to be able to prepare the necessary data and files to be able to use it properly. There is a steep learning curve with the average time required to reach a proficient level of 7 months (Janßen et al., 2019). Because of the technical challenges of working with Marxan, there have been many tools, plugins and apps that have been developed to help in certain workflows. These have been developed and supported by the burgeoning Marxan community which also includes a number of providers of Marxan training. To date over 800 people have been trained in the use of Marxan. However, nearly all of the training focuses on how to prepare data for use within Marxan rather than on the business problem of SCP and how to select the best protected area system.

## Vision
The vision for the new version of the Marxan software, called Marxan Web, is to:
- Make SCP accessible and available to all - especially decision makers and staff with no specialist technical knowledge.
- Be able to integrate and share content easily between organisation involved in SCP and external data providers.
- Be able to publish, share and iterate proposed new protected area networks with key stakeholders.

## Challenges/technical considerations
There are many challenges associated with the existing Marxan software which are outlined in this section and these challenges will in many ways dictate the technical architecture for the system. Therefore, this section also includes many of the system technical requirements.

Firstly, the most challenging aspect of Marxan is the steep learning curve and the amount of time that is required to identify new reserve systems. Marxan Web will have to remove all of the technically challenging parts of the SCP workflow while maintaining the scientific robustness of the tool. All workflows should be possible within a single user interface without having to resort to any other external tools. Navigation and use of the tool should be as intuitive as possible and support different roles (i.e. feature sets) depending on the level of expertise of the user and the user needs. For example, a hardcore Marxan user may want to have access to all of the various parameters for optimising Marxan whereas a decision maker in a government department may only want to see the results and include/exclude individual areas from a proposed new network.

The installation of Marxan and its various external tools can be particularly problematic and involved and this can be a technical barrier to uptake. Marxan Web should be available as a hosted service (i.e. running in a browser on the cloud with no installation required) to get users up and running with zero effort.

Although Marxan is a powerful tool for identifying proposed new networks, this comes at the cost of processing demands. The mathematical algorithms are particularly expensive in terms of processing and therefore any new tool will have to be able to scale to multiple concurrent users running projects, particularly during periods of training where there may be up to 30 people all using the tool at the same time. Scaling could also be achieved by providing a number of hosted services for running Marxan Web, for example in each of the BIOPAMA regions. This could also be highly beneficial in that regional installations of Marxan Web could offer regionally relevant data and content to their users. Finally, ensuring that the application will scale could also be achieved by offering the same user interface running on local machines.

Given that the proposed system will be running as a hosted service on the cloud, there must be solid, reliable security. This security will provide controlled access to features and data and will allow organisations who have sensitive information to be able to restrict access to it.

Another challenge in the existing Marxan software is the ability to share content between users. If a number of users are working on the same protected area network at the same institution, they cannot share the data that is input to their analyses. All data has to be duplicated on every local computer. In addition, there is no provision for integrating content from elsewhere easily (e.g. from web services). The new version of Marxan will need to ensure that content can be shared easily between different users and that new content can be incorporated seamlessly from external data providers. For example, the Global Biodiversity Information Facility (GBIF) is a global provider of species data that could be used in Marxan Web and they provide a range of web services to allow the integration of data directly into web-based tools.

The existing Marxan tool itself does not have a graphical user interface and all results have to be exported to an external GIS tool. This makes visualising the results extremely cumbersome and inefficient. A GIS plugin has been developed, called CLUZ, but it still requires advanced GIS knowledge and the installation of software and extensions which puts it out of reach for non-technical users.

Another requirement for the new Marxan software is to provide access to the content that is generated in the system to other tools and interfaces so that the information can be used for different purposes. For example, if a National government wants to communicate the results of an SCP to its stakeholders in its own website, then it should be able to integrate content from Marxan Web easily. This Service Oriented Architecture will enable the reuse of valuable conservation related data.

Any software developed with funding from the European Commission must adhere to the policy of being public, free and open. In practical terms this means that the software and source code must be available to anyone else to use with no restriction on use. In addition, the software must be engineered in such a way as to make new features or extensions as easy as possible to integrate. For example, the Marxan software uses a specific algorithm to solve the spatial planning problem, but there are a number of such algorithms available. It should be as easy as possible to integrate new solvers into Marxan Web that have been developed by other organisations.

Finally, SCP is a tool that is used almost exclusively in the academic and scientific communities. Where national and regional governments use SCP they tend to contract out Universities or consultants to do detailed studies and then to present the results back to them at the end of the process. This process can take many months and this can make it difficult to iterate with stakeholders on the recommendations from the SCP. If proposed new protected areas are unsuitable or impractical then the whole study may have to be repeated again. This lag in the process is expensive in terms of both time and money and the new tool must provide a near-realtime way of iterating with governments or decision makers.

#### Data sharing
#### Scope/system boundaries
## Workplan
### Activities
#### Requirements analysis/gathering
Meetings with partners
System specification with features list
#### Software development
#### Documentation
#### Iteration/testing
##### Test suites
##### Issue tracker
#### Review
#### Training resources development
#### Content development
More long term with partners
Also content can come directly from web services, e.g. WFS, GBIF etc.
#### Onboarding
##### Roll-out
To the BIOPAMA regions
##### Training
##### Capacity Building
### Deliverables
tool
docs
case studies
test suites
source code

### Roles and responsibilities
## Partners
## Sustainability
### Governance
## Measurement of impact
## References
Gannon, Patrick & Seyoum-Edjigu, Edjigayehu & Cooper, H. & Sandwith, Trevor & Ferreira de Souza Dias, Braulio & Palmer, Cristiana & Lang, Barbara & Ervin, Jamison & Gidda, Sarat. (2017). Status and prospects for achieving Aichi Biodiversity Target 11: Implications of national commitments and priority actions. Parks. 23. 13-26. 10.2305/IUCN.CH.2017.PARKS-23-2PG.en.
Holger Janßen, Cordula Göke, Anne Luttmann, Knowledge integration in Marine Spatial Planning: A practitioners' view on decision support tools with special focus on Marxan, Ocean & Coastal Management, Volume 168, 2019
