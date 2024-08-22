# The different types of rights

Collec-Science manages 6 different rights:

- admin
- param
- collection
- import
- gestion
- consult

## The *admin* right

It allows you to create users, to assign rights, to set the general data of the software, to consult the traces, to make a one-time backup of the database.

It is independent of the other rights. It is generally held by the system administrators.

## The *param* right

This is the super-user of the application. He can do everything in the software, except what is assigned to the *admin* right, and in particular :

- modify all the parameter tables
- creation of collections.

In general, the holder of the *param* right should also have the *admin* right (the reverse is not necessarily true).

## The *collection* right

This is a right given to collection administrators. They can change most of the settings like creating sample types, metadata templates, etc., and perform imports for the collections they belong to.

## The *import* right

It allows to import samples for the collections to which the user belongs.

## The *gestion* right

This is the basic right for active users in the software. It allows to :

- create/modify samples for the collections to which the user belongs
- record input/output movements for all samples, including those that are not part of his collections

As soon as a user is attached to a collection, he automatically inherits this right.

## The *consult* right

Any user with this right can view existing samples, but cannot view the attached metadata.

*Editor : Éric Quinton - 2022-05-20*

Translated with www.DeepL.com/Translator (free version)