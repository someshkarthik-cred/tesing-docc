import class Foundation.Bundle

extension Foundation.Bundle {
    static var module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("SlothCreator_SlothCreator.bundle").path
        let buildPath = "/Users/someshkarthik/tesing-docc/.build/arm64-apple-macosx/debug/SlothCreator_SlothCreator.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}
