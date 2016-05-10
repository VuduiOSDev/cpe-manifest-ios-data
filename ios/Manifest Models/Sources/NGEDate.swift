
import Foundation

@objc
class NGEDate : NSObject{
    
    var scheduled: Bool?
    
    /**
    the type's underlying value
    */
    var value: NSDate?
    
    func readAttributes(reader: xmlTextReaderPtr) {
        let dateOnlyFormatter = NSDateFormatter()
        dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
        dateOnlyFormatter.timeZone = NSTimeZone(name:"UTC")
        
        let scheduledAttrName = UnsafePointer<xmlChar>(NSString(stringLiteral: "scheduled").UTF8String)
        let scheduledAttrValue = xmlTextReaderGetAttribute(reader, scheduledAttrName)
        if(scheduledAttrValue != nil) {
            
            self.scheduled = (String.fromCString(UnsafePointer<CChar>(scheduledAttrValue)) == "true")
            xmlFree(scheduledAttrValue)
        }
    }
    
    init(reader: xmlTextReaderPtr) {
        let _complexTypeXmlDept = xmlTextReaderDepth(reader)
        super.init()
        
        let dateOnlyFormatter = NSDateFormatter()
        dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
        dateOnlyFormatter.timeZone = NSTimeZone(name:"UTC")
        
        self.readAttributes(reader)
        
        var _readerOk = xmlTextReaderRead(reader)
        var _currentNodeType = xmlTextReaderNodeType(reader)
        var _currentXmlDept = xmlTextReaderDepth(reader)
        
        while(_readerOk > 0 && _currentNodeType != 0/*XML_READER_TYPE_NONE*/ && _complexTypeXmlDept < _currentXmlDept) {
            
            if(_currentNodeType == 1/*XML_READER_TYPE_ELEMENT*/ || _currentNodeType == 3/*XML_READER_TYPE_TEXT*/) {
                let _currentElementNameXmlChar = xmlTextReaderConstLocalName(reader)
                let _currentElementName = String.fromCString(UnsafePointer<CChar>(_currentElementNameXmlChar))
                if("#text" == _currentElementName){
                    let contentValue = xmlTextReaderConstValue(reader)
                    if(contentValue != nil) {
                        let dateOnlyFormatter = NSDateFormatter()
                        dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
                        dateOnlyFormatter.timeZone = NSTimeZone(name:"UTC")
                        
                        let value = String.fromCString(UnsafePointer<CChar>(contentValue))
                        if value != nil {
                            let trimmed = value!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                            self.value = dateOnlyFormatter.dateFromString(trimmed)
                        }
                    }
                } else  if(true) {
                    print("Ignoring unexpected in NGEDate: \(_currentElementName)")
                    if superclass != NSObject.self {
                        break
                    }
                }
            }
            _readerOk = xmlTextReaderRead(reader)
            _currentNodeType = xmlTextReaderNodeType(reader)
            _currentXmlDept = xmlTextReaderDepth(reader)
        }
        
    }
    
    /*var dictionary: [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if(self.scheduled != nil) {
            
            dict["scheduled"] = self.scheduled!
            
        }
        
        if(self.value != nil) {
            
            dict["value"] = self.value!
            
        }
        
        return dict
    }*/
    
}

