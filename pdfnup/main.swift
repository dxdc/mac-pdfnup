import Foundation

let help = "Usage: pdfnup --output <out> --nup 1/2/4/6 <filelist>";

do {
    var arguments = CommandLine.arguments.dropFirst()
    guard let outputFlagIndex = arguments.firstIndex(where: { $0 == "-o" || $0 == "--output" }),
        let outputIndex = arguments.index(outputFlagIndex, offsetBy: 1, limitedBy: arguments.endIndex) else {
            throw CommandError.missingArgument(key: "output path")
    }
    let output = URL(fileURLWithPath: arguments[outputIndex])
    arguments.removeSubrange(outputFlagIndex ... outputIndex)
    
    var nup = "2"
    if let nupFlagIndex = arguments.firstIndex(where: { $0 == "-n" || $0 == "--nup" }),
        let nupIndex = arguments.index(nupFlagIndex, offsetBy: 1, limitedBy: arguments.endIndex) {
        nup = arguments[nupIndex]
        arguments.removeSubrange(nupFlagIndex ... nupIndex)
    }
    guard let nupMode = NupMode(rawValue: nup) else {
        throw CommandError.missingArgument(key: "nup mode can only be 1, 2, or 6")
    }

    let inputs = arguments.map(URL.init(fileURLWithPath:))
    let action = CombinePDFs(inputs: inputs, output: output, nup: nupMode)
    try action.run()

    exit(0)
} catch {
    fputs("error: \(error)\n\(help)\n", stderr)
    exit(1)
}
