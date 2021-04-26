import mamba

extension HLSTag {
    func value(_ pantosValue: PantosValue) -> String? {
        value(forValueIdentifier: pantosValue)
    }
    
    func value<T: FailableStringLiteralConvertible>(_ pantosValue: PantosValue) -> T? {
        value(forValueIdentifier: pantosValue)
    }
}
