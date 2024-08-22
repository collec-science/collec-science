# Lend one or more samples

It is possible to track the loan of samples to third party laboratories, with a dedicated function. The loan can concern either a single sample or a set of samples, for example a box of tubes.

## General principle

The lent objects (containers or samples) take the status "lent". At the time of the loan, the borrower must be designated, and an expected return date can be set.

Upon return of the samples or containers, the objects return to "normal" status.

The loan only works for "complete" samples. It is not possible to lend only a part of a sample (sub-sampling): in this case, you must first create a derived sample containing the part of the main sample. It is the derived sample, whole (but part of the main sample), that will be loaned.

## Create borrowers

From the settings menu, choose *Borrowers*. From the list, you can either create a new borrower or view the samples or containers that have been loaned to them. 

## Loan one or more objects

From the list of samples or containers, you can lend items directly. If you lend a container, all the samples or containers it contains will also be marked as lent. Each sample or container can be treated independently of the others, i.e. have a different return date.

It is also possible to lend an object from its details, in the tab *Events/Loans*.

## Generate the list of objects exported in a container

If you export a container with its samples, you can generate a file that can be imported in the Collec-Science instance of your borrower.

To do so, from the *Objects > Containers* menu, select the container(s) concerned, then click on the "Export with objects included" button. A JSON file will be generated, which you can send to your borrower.

The borrower will be able to import the container and the associated samples in his database, from the menu *Imports/Exports > External containers imports*.
At the time of the import, an input transaction will be generated for all the samples present in the container.

The generation of this file does not dispense with the actual loan operation.

## Reintegrate the samples

Once the borrower has returned the samples, you can reintegrate them into the software.

There are two possible approaches: 

- in the sample details, then in the loan details, enter the *actual return date*: the status will be automatically set to "Normal status" at the time of registration;
- create a movement of entry of the object, either global, or object by object: the status will be positioned automatically at "Normal state", the date of return of the loan will also be filled in at the current date.


Translated with www.DeepL.com/Translator (free version)