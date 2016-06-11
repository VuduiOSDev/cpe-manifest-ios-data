import Foundation

#if (arch(i386) || arch(x86_64)) && os(iOS)
import libxmlSimu
#else
import libxml
#endif

@objc
class NGEDigitalAssetCardsetType : NSObject{
    
    var TypeList: [String]!
    
    var Description: String?
    
    var Sequence: Int?
    
    var LanguageList: [String]?
    
    func readAttributes(reader: xmlTextReaderPtr) {
        
        let numFormatter = NSNumberFormatter()
        numFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
    }
    
    init(reader: xmlTextReaderPtr) {
        let _complexTypeXmlDept = xmlTextReaderDepth(reader)
        super.init()
        
        let numFormatter = NSNumberFormatter()
        numFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        self.readAttributes(reader)
        
        var TypeListArray = [String]()
        
        var LanguageListArray = [String]()
        
        var _readerOk = xmlTextReaderRead(reader)
        var _currentNodeType = xmlTextReaderNodeType(reader)
        var _currentXmlDept = xmlTextReaderDepth(reader)
        
        while(_readerOk > 0 && _currentNodeType != 0/*XML_READER_TYPE_NONE*/ && _complexTypeXmlDept < _currentXmlDept) {
            
            if(_currentNodeType == 1/*XML_READER_TYPE_ELEMENT*/ || _currentNodeType == 3/*XML_READER_TYPE_TEXT*/) {
                let _currentElementNameXmlChar = xmlTextReaderConstLocalName(reader)
                let _currentElementName = String.fromCString(UnsafePointer<CChar>(_currentElementNameXmlChar))
                if("Type" == _currentElementName) {
                    
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    let TypeElementValue = xmlTextReaderConstValue(reader)
                    if TypeElementValue != nil {
                        
                        TypeListArray.append(String.fromCString(UnsafePointer<CChar>(TypeElementValue))!)
                    }
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("Description" == _currentElementName) {
                    
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    let DescriptionElementValue = xmlTextReaderConstValue(reader)
                    if DescriptionElementValue != nil {
                        
                        self.Description = String.fromCString(UnsafePointer<CChar>(DescriptionElementValue))
                        
                    }
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("Sequence" == _currentElementName) {
                    
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    let SequenceElementValue = xmlTextReaderConstValue(reader)
                    if SequenceElementValue != nil {
                        
                        self.Sequence = numFormatter.numberFromString(String.fromCString(UnsafePointer<CChar>(SequenceElementValue))!)!.integerValue
                        
                    }
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("Language" == _currentElementName) {
                    
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    let LanguageElementValue = xmlTextReaderConstValue(reader)
                    if LanguageElementValue != nil {
                        
                        LanguageListArray.append(String.fromCString(UnsafePointer<CChar>(LanguageElementValue))!)
                    }
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else   if(true) {
                    print("Ignoring unexpected in NGEDigitalAssetCardsetType: \(_currentElementName)")
                    if superclass != NSObject.self {
                        break
                    }
                }
            }
            _readerOk = xmlTextReaderRead(reader)
            _currentNodeType = xmlTextReaderNodeType(reader)
            _currentXmlDept = xmlTextReaderDepth(reader)
        }
        
        if(TypeListArray.count > 0) { self.TypeList = TypeListArray }
        
        if(LanguageListArray.count > 0) { self.LanguageList = LanguageListArray }
    }
    
    /*var dictionary: [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if(self.TypeList != nil) {
            
            dict["TypeList"] = self.TypeList!
            
        }
        
        if(self.Description != nil) {
            
            dict["Description"] = self.Description!
            
        }
        
        if(self.Sequence != nil) {
            
            dict["Sequence"] = self.Sequence!
            
        }
        
        if(self.LanguageList != nil) {
            
            dict["LanguageList"] = self.LanguageList!
            
        }
        
        return dict
    }*/
    
}
