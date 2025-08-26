# FixedHeader for DataTables 

This is the distribution package for the [FixedHeader extension](https://datatables.net/extensions/fixedheader) for [DataTables](https://datatables.net/). Only the core software for this library is contained in this package - to be correctly styled, a styling package for FixedHeader must also be included. Please see the [npm installation documentation on the DataTables site](https://datatables.net/manual/installation#Node.js-/-NPM) for full details.

When displaying large amounts of data in a table, it can often be useful for the end user to have the column titles always visible. This is particularly true if using DataTables with pagination disabled, or the display length is set to a high value. The FixedHeader extension provides this ability.


## Installation

### Browser

To use DataTables with a simple `<script>` tag, rather than using this package, it is recommended that you use the [DataTables download builder](//datatables.net/download) which can create CDN or locally hosted packages for you, will all dependencies satisfied.

### npm

For installation via npm, yarn and other similar package managers, install this package with your package manager - e.g.:

```
npm install datatables.net
npm install datatables.net-fixedheader
```

Then, to load and initialise DataTables and FixedHeader in your code use:

```
import DataTable from 'datatables.net';
import 'datatables.net-fixedheader'

new DataTable('#myTable', {
    // initialisation options
});
```


## Documentation

Full documentation and examples for FixedHeader can be found [on the DataTables website](https://datatables.net/extensions/fixedheader).

## Bug / Support

Support for DataTables is available through the [DataTables forums](//datatables.net/forums) and [commercial support options](//datatables.net/support) are available.

### Contributing

If you are thinking of contributing code to DataTables, first of all, thank you! All fixes, patches and enhancements to DataTables are very warmly welcomed. This repository is a distribution repo, so patches and issues sent to this repo will not be accepted. Instead, please direct pull requests to the [DataTables/FixedHeader](http://github.com/DataTables/FixedHeader). For issues / bugs, please direct your questions to the [DataTables forums](//datatables.net/forums).


## License

This software is released under the [MIT license](//datatables.net/license). You are free to use, modify and distribute this software, but all copyright information must remain.
