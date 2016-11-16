# cpe-manifest-ios-data
Manifest.XML parser and full one-to-one mapping of the Manifest and Common Metadata specs to Swift objects

## Development Installation
Clone a copy of the repository:

    git clone git@github.com:warnerbros/cpe-manifest-ios-data.git
    cd cpe-manifest-ios-data

Update `NextGenDataManager.podspec` to point `SWIFT_INCLUDE_PATHS` to the `libxml` folder from this repository.

Install example project dependencies:

    cd Example
    pod install

Open `NextGenDataManagerExampleWorkspace.xcworkspace`, edit `ViewController.swift` to point to your sample data XML file, and run.
