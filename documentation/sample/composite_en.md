# Composite samples

Composite samples are samples created from several different samples. In general, they are used either to reduce the cost of analyses (average value from several samples), or when there is not enough material to carry out an analysis with a single sample.

In Collec-Science, composite samples are treated as a variant of *sub-sampling*. A certain quantity of one or more samples is taken to form a new sample. This approach was preferred to that which would have consisted of creating derived samples, the latter being technically speaking strictly linked to a parent.

## Prerequisites

The sample types concerned (donor samples, composite samples) must have the *sub-sampling nature* filled in, for the sub-sampling tab to be activated for the samples in question.

## Create a composite sample

There are two possible approaches:

- either from the list of samples :
  - select the donor samples
  - in the menu at the bottom of the list, choose *Create a composite sample from the selected samples*.
  - enter the quantity to be removed from the donor samples, and the quantity allocated to the sample to be created
  - indicate the collection, then the type of composite sample
  - you can search for an existing sample to add a donor sample. In this case, you will not be able to change the quantity allocated, the collection or the type of sample. However, you can carry out these operations from the details of the composite sample
- or from the details of a donor sample, by creating a new sub-sample:
  - you can enter the same information and, if necessary, search for an existing sample.

The sample created includes the main characteristics of the first sample selected (created from the list) or of the donor sample, such as metadata, referent, collection campaign, etc.