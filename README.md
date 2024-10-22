# COLLEC-SCIENCE  

© INRAE, 2016-2024 - All rights reserved  
Published under AGPL license

**WARNING**: Collec-Science is now hosted here: [https://github.com/collec-science/collec-science](https://github.com/collec-science/collec-science)

Collec-Science is written with PHP, use the CodeIgniter framework and the complementary module [equinton/ppci](https://github.com/equinton/ppci). The documentation of *ppci* is available here: [https://equinton.github.io/ppcidocs](https://equinton.github.io/ppcidocs).

## Install

To install a new instance in Ubuntu or Debian server:

```
wget https://github.com/collec-science/collec-science/raw/main/install/deploy_new_instance.sh
sudo -s
./deploy_new_instance.sh
```

## Upgrade

From version 24.0.0, the technology used to upgrade the application change. Consult this doc: [https://github.com/collec-science/collec-science/blob/main/install/update%20collec-science%20from%20version%2024.0.0_en.md](https://github.com/collec-science/collec-science/blob/main/install/update%20collec-science%20from%20version%2024.0.0_en.md)

## What is it?

Collec-science is a software designed to manage collections of samples collected in the field.

Written in PHP, it works with a Postgresql database. It is built around the concept of objects, which are identified by a unique number. An object can be of two types: a container (both a site, a building, a room, a freezer, a cashier ...) than a sample.  
A type of sample can be attached to a type of container, when the two notions are superimposed (the bottle containing the result of a fishing is both a container and the sample itself).  
An object can be attached to several different business identifiers, events, or reservations.  
A sample can be subdivided into other samples (of the same type or not). It can contain several identical elements (notion of subsampling), like undifferentiated fish scales.  
A sample is necessarily attached to a collection. Modification rights are assigned at the collection.


## Main features

- Entry / exit of the stock of any object (a container can be placed in another container, such as a box in a cupboard, a cupboard in a room, etc.)
- possibility to generate labels with or without QRCODE
- event management for any object
- reservation of any object
- scanner reading (handheld) QRCODE, object by object, or in batch mode (multiple reading, then integration of movements in a single operation)
- individual reading of QRCODES by tablet or smartphone (tested, but not very practical for performance reasons)
- adding photos or attachments to any object
- each sample can be derivated in others samples of the same type or not. It is possible to record the sampling of a part of the sample, to create or not a new sample. From v25.0.0 release, a sample can be created from multiple samples (composite samples).

## Security

- software approved in 2019 by Irstea, resistant to opportunistic attacks according to the nomenclature of OWASP (ASVS project), but probably capable of meeting the needs of the standard level
- possible identification according to several modalities: internal account database, ldap directory, ldap - database (mixed identification), via CAS server, or by delegation to an identification proxy server, such as LemonLDAP, for example
- rights management that can rely on groups in an LDAP directory

## License

Software diffused under AGPL License

## Copyright

Version 1.0 has been recorded with the French Agence de Protection des Programmes under the number IDDN.FR.001.470013.000.S.C.2016.000.31500

# Online documentation

Technical documentation is available here : [https://collec-science.github.io/docs/](https://collec-science.github.io/docs/)
