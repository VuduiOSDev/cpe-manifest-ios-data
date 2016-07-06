//
//  NGDMAppData.swift
//

import Foundation

public enum NGDMAppDataImageType {
    case Location
    case MediaThumbnail
}

// Wrapper class for `NGEExperienceAppType` Manifest object
public class NGDMAppData {
    
    private struct NVPairName {
        static let AppType = "type"
        static let Location = "location"
        static let Text = "text"
        static let Zoom = "zoom"
        static let VideoId = "video_id"
        static let GalleryId = "gallery_id"
        static let LocationThumbnail = "location_thumbnail"
        static let VideoThumbnail = "video_thumbnail"
        static let GalleryThumbnail = "gallery_thumbnail"
    }
    
    // MARK: Instance Variables
    /// Unique identifier
    var id: String!
    
    /// Metadata
    public var title: String?
    public var subtitle: String? {
        return location?.name
    }
    
    public var displayText: String?
    
    var locationImageURL: NSURL?
    var videoThumbnailImageURL: NSURL?
    
    /// Media
    public var presentation: NGDMPresentation?
    public var audioVisual: NGDMAudioVisual?
    public var gallery: NGDMGallery?
    public var location: NGDMLocation?
    public var zoomLevel: Float = 0
    
    public var videoURL: NSURL? {
        return presentation?.videoURL
    }
    
    /// Check if AppData is location-based
    var isLocation: Bool {
        return location != nil
    }
    
    public var hasVideo: Bool {
        return videoURL != nil
    }
    
    public var hasGallery: Bool {
        return gallery != nil
    }
    
    // MARK: Initialization
    /**
        Initializes a new AppData
     
        - Parameters:
            - manifestObject: Raw Manifest data object
     */
    init(manifestObject: NGEAppDataType) {
        id = manifestObject.AppID
        
        for obj in manifestObject.NVPairList {
            switch obj.Name {
            case NVPairName.AppType:
                title = obj.Text
                break
                
            case NVPairName.Text:
                displayText = obj.Text
                break
                
            case NVPairName.Location:
                if let obj = obj.Location {
                    location = NGDMLocation(manifestObject: obj)
                } else if let obj = obj.LocationSet?.LocationList?.first {
                    location = NGDMLocation(manifestObject: obj)
                }
                
                break
                
            case NVPairName.Zoom:
                zoomLevel = Float(obj.Integer ?? 0)
                break
                
            case NVPairName.VideoId:
                if let id = obj.PresentationID {
                    presentation = NGDMPresentation.getById(id)
                    audioVisual = NGDMAudioVisual.getById(id)
                }
                
                break
                
            case NVPairName.GalleryId:
                if let id = obj.Gallery?.GalleryID {
                    gallery = NGDMGallery.getById(id)
                }
                
                break
                
            case NVPairName.VideoThumbnail, NVPairName.GalleryThumbnail:
                if let id = obj.PictureID {
                    videoThumbnailImageURL = NGDMImage.getById(id)?.url
                }
                
                break
                
            case NVPairName.LocationThumbnail:
                if let id = obj.PictureID {
                    locationImageURL = NGDMImage.getById(id)?.url
                }
                
            default:
                break
            }
        }
    }
    
    // MARK: Helpers
    public func getImageURL(imageType: NGDMAppDataImageType) -> NSURL? {
        switch imageType {
        case .Location:
            return locationImageURL ?? videoThumbnailImageURL
            
        case .MediaThumbnail:
            if hasVideo {
                return videoThumbnailImageURL
            }
            
            if hasGallery {
                return gallery!.imageURL
            }
            
            return locationImageURL
            
        default:
            return nil
        }
    }
    
}