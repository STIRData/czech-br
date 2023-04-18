# Czech Business Registry transformations
This repository contains [LinkedPipes ETL] transformation pipelines used to transform the [Czech Business Registry] from its XML representation.
1. First, a proper representation in RDF according to the [Semantic Government Vocabulary] is created.
2. Second, the Semantic Government Vocabulary representation is transformed to the European Business Graph vocabulary representation used in the [STIRData] project.

## Source data
The source data was available in the [Czech National Open Data Portal]. However, the publisher deployed a new data catalog, which does not provide metadata to be harvested by the national catalog at the moment. [The datasets](https://dataor.justice.cz/), available directly from the data publisher, are split by year - historical per-year snapshots + actual year, region (actually regional court managing that part of the registry) and full/valid records, where in the valid records, some of the deprecated information about no longer existing companies is missing.

Each dataset has 4 distributions: XML, CSV (ugly with embedded JSON values), Zipped XML and Zipped CSV.
We use the XML representation for further transformation.

## Transformation from source to Semantic Government Vocabulary version
![LinkedPipes ETL pipeline transforming Czech Business Registry to Semantic Government Vocabulary version](assets/images/sgov-pipeline.webp)

1. [The pipeline](assets/pipelines/sgov.jsonld) accesses the https://data.gov.cz/sparql SPARQL endpoint of the [Czech National Open Data Portal] and searches for the datasets of the business registry - all regions, year 2021, full version, specifically their XML version
2. The files are converted to initial RDF using XSLT transformations
3. The RDF is further refined based on different aspects of the company records. The blue parts are common for all company types. The yellow-green parts are specific to joint-stock companies, the pink parts are specific to the limited liability companies. The green parts on top generate codelists from the data.
4. The full ontological representation is then compacted to form a LOD-style RDF version of the data. This is the version to be published by the Business registry, if we succeed in convincing them. Therefore, this is the source of the transformation to the STIRData model.
5. The whole process takes approx. 20 hours to complete, depending on the used hardware.

## Transformation from Semantic Government Vocabulary version to STIRData model
![LinkedPipes ETL pipeline transforming Czech Business Registry to STIRData version](assets/images/stir-pipeline.webp)
[This pipeline](assets/pipelines/stir.jsonld) pipeline converts the result of the previous one to the [STIRData specification](https://stirdata.github.io/data-specification/), so far using a single SPARQL query.
Then, the mapping to NUTS codes via a Czech cadastre dataset is done using Federated SPARQL query to the Charles University RDF version of the Czech cadastre, resulting in a mapping in [RDF TriG](https://obchodní-rejstřík.stirdata.opendata.cz/soubor/or-ebg-nuts.trig).
Finally, the results of the transformation are dumped to [RDF TriG](https://obchodní-rejstřík.stirdata.opendata.cz/soubor/or-ebg.trig).
Also, an [HDT dump](https://obchodní-rejstřík.stirdata.opendata.cz/soubor/or.trig) is created and the Linked Data Fragments server gets pinged to reload the HDT file.
The whole process takes approx. 3 hours to complete.

## Mapping to CZ-NACE activity codes
An additional dataset from the Czech Statistical Office (see in [data.gov.cz](https://data.gov.cz/datová-sada?iri=https%3A%2F%2Fdata.gov.cz%2Fzdroj%2Fdatové-sady%2F00025593%2F7bad26fdd8554ce715b81b5b416d75f0) and [data.europa.eu](https://data.europa.eu/data/datasets/https-vdb-czso-cz-pll-eweb-lkod_ld-datova_sada-nazev-registr_ekonomickych_subjektu_seznam)), a classification of the Czech companies using the Czech extension to NACE codes CZ-NACE, is [processed using an additional pipeline](assets/pipelines/nace-mapping.jsonld).
It is mapping Czech companies to the CZ-NACE codes, which themselves are published by the Czech Statistical Office (see in [data.gov.cz](https://data.gov.cz/datová-sada?iri=https://data.gov.cz/zdroj/datové-sady/00025593/f884f59498ad1717083b498b21ef2283) and [data.europa.eu](https://data.europa.eu/data/datasets/https-vdb-czso-cz-pll-eweb-lkod_ld-datova_sada-nazev-klasifikace_ekonomickych_cinnosti_cz_nace)) and processed using another [pipeline](assets/pipelines/cz-nace.jsonld), resulting in RDF and SKOS version of the classification (see [data.gov.cz](https://data.gov.cz/datová-sada?iri=https%3A%2F%2Fdata.gov.cz%2Fzdroj%2Fdatové-sady%2F00216208%2F03c70bed41ee7397c72b6daeba9257a4), [data.europa.eu](https://data.europa.eu/data/datasets/https-lkod-mff-cuni-cz-zdroj-datove-sady-stirdata-cz-nace-stirdata)).

## Loading of data into triplestores
Customizable pipelines are available for loading the produced data into [Apache Jena Fuseki](assets/pipelines/fuseki.jsonld) and [OpenLink Virtuoso](assets/pipelines/virtuoso.jsonld).

## Presentation
The dataset is registered in the [STIRData data catalog](https://stirdata.opendata.cz/datasets), the [Czech National Open Data Catalog](https://data.gov.cz/datová-sada?iri=https%3A%2F%2Fdata.gov.cz%2Fzdroj%2Fdatové-sady%2F00216208%2Fe9a83e226dc746c02dd05aa4688359ad) and the [Official portal for European data](https://data.europa.eu/data/datasets/https-lkod-mff-cuni-cz-zdroj-datove-sady-stirdata-obchodni-rejstr-i-k-stirdata).
It is distributed as [RDF TriG dump](https://obchodní-rejstřík.stirdata.opendata.cz/soubor/or.trig), [HDT dump](https://obchodní-rejstřík.stirdata.opendata.cz/soubor/or.trig), [SPARQL endpoint powered by Apache Jena Fuseki](https://obchodní-rejstřík.stirdata.opendata.cz/sparql), [SPARQL endpoint powered by OpenLink Virtuoso](https://obchodní-rejstřík.stirdata.opendata.cz/sparql) and as [Linked Data Fragments endpoint](https://obchodní-rejstřík.stirdata.opendata.cz/ldf/).

[LinkedPipes ETL]: https://etl.linkedpipes.com "LinkedPipes ETL"
[Semantic Government Vocabulary]: https://doi.org/10.1016/j.websem.2018.12.009 "Semantic Government Vocabulary"
[STIRData]: https://stirdata.eu "STIRData"
[Czech National Open Data Portal]: https://data.gov.cz/en "Czech National Open Data Portal"