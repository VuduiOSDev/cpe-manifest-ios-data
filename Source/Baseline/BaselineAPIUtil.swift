//
//  BaselineAPIUtil.swift
//

import Foundation

public enum BaselineAPIStudio: String {
    case wb = "WB"
    case nbcu = "NBCU"
}

public class BaselineAPIUtil: APIUtil, TalentAPIUtil {

    public static var APIDomain = "https://talent-api.crossplatformextras.com"
    public static var APINamespace = "baselineapi.com"

    private struct Endpoints {
        static let GetCredits = "/film/credits"
        static let GetTalentImages = "/talent/images"
        static let GetTalentDetails = "/talent"
    }

    private struct Keys {
        static let ParticipantID = "PARTICIPANT_ID"
        static let FullName = "FULL_NAME"
        static let Credit = "CREDIT"
        static let CreditGroup = "CREDIT_GROUP"
        static let Role = "ROLE"
        static let Filmography = "FILMOGRAPHY"
        static let SocialAccounts = "SOCIAL_ACCOUNTS"
        static let Posters = "POSTERS"
        static let ShortBio = "SHORT_BIO"
        static let MediumURL = "MEDIUM_URL"
        static let LargeURL = "LARGE_URL"
        static let FullURL = "FULL_URL"
        static let ProjectID = "PROJECT_ID"
        static let ProjectName = "PROJECT_NAME"
        static let Handle = "HANDLE"
        static let URL = "URL"
    }

    struct Headers {
        static let APIKey = "x-api-key"
        static let Studio = "X-Studio"
    }

    private struct Constants {
        static let MaxCredits = 15
        static let MaxFilmography = 10
    }

    public var featureAPIID: String?

    public convenience init(apiKey: String, featureAPIID: String? = nil, studio: BaselineAPIStudio = .wb) {
        self.init(apiDomain: BaselineAPIUtil.APIDomain)

        self.featureAPIID = featureAPIID
        self.customHeaders[Headers.APIKey] = apiKey
        self.customHeaders[Headers.Studio] = studio.rawValue
    }

    open func prefetchPeople(_ completionHandler: @escaping (_ people: [Person]?) -> Void) {
        if let apiID = featureAPIID {
            _ = getJSONWithPath(Endpoints.GetCredits, parameters: ["id": apiID], successBlock: { (result) -> Void in
                if let results = result["result"] as? NSArray {
                    var people = [Person]()

                    var i = 0
                    for talentInfo in results.subarray(with: NSRange(location: 0, length: min(Constants.MaxCredits, results.count))) {
                        if let talentInfo = talentInfo as? NSDictionary, let talentID = talentInfo[Keys.ParticipantID] as? NSNumber, let name = (talentInfo[Keys.FullName] as? String) {
                            let jobFunction = PersonJobFunction.build(rawValue: (talentInfo[Keys.Credit] as? String))
                            let character = talentInfo[Keys.Credit] as? String
                            people.append(Person(apiID: talentID.stringValue, name: name, jobFunction: jobFunction, billingBlockOrder: i, character: character))
                        }

                        i += 1
                    }

                    completionHandler(people)
                }
            }, errorBlock: { (error) in
                print("Error fetching credits for ID \(apiID): \(error?.localizedDescription ?? "Unknown error")")
                completionHandler(nil)
            })
        } else {
            completionHandler(nil)
        }
    }

    open func fetchImages(forPersonID id: String, completionHandler: @escaping (_ pictureGroup: PictureGroup?) -> Void) {
        _ = getJSONWithPath(Endpoints.GetTalentImages, parameters: ["id": id], successBlock: { (result) -> Void in
            if let results = result["result"] as? NSArray, results.count > 0 {
                var pictures = [Picture]()
                for talentImageInfo in results {
                    if let talentImageInfo = talentImageInfo as? NSDictionary {
                        var thumbnailImageURL: URL?
                        if let thumbnailURLString = talentImageInfo[Keys.MediumURL] as? String {
                            thumbnailImageURL = URL(string: thumbnailURLString)
                        }

                        if let imageURLString = talentImageInfo[Keys.FullURL] as? String, let imageURL = URL(string: imageURLString) {
                            pictures.append(Picture(imageURL: imageURL, thumbnailImageURL: thumbnailImageURL))
                        }
                    }
                }

                completionHandler(PictureGroup(pictures: pictures))
            } else {
                completionHandler(nil)
            }
        }, errorBlock: { (error) in
            print("Error fetching talent images for ID \(id): \(error?.localizedDescription ?? "Unknown error")")
            completionHandler(nil)
        })
    }

    open func fetchDetails(forPersonID id: String, completionHandler: @escaping (_ biography: String?, _ socialAccounts: [SocialAccount]?, _ films: [Film]) -> Void) {
        _ = getJSONWithPath(Endpoints.GetTalentDetails, parameters: ["id": id], successBlock: { (result) in
            var socialAccounts = [SocialAccount]()
            if let socialAccountInfoList = result[Keys.SocialAccounts] as? NSArray {
                for socialAccountInfo in socialAccountInfoList {
                    if let socialAccountInfo = socialAccountInfo as? NSDictionary {
                        guard let handle = socialAccountInfo[Keys.Handle] as? String else {
                            print("Ignoring social account object with missing handle: \(socialAccountInfo)")
                            continue
                        }

                        guard let urlString = socialAccountInfo[Keys.URL] as? String else {
                            print("Ignoring social account object with missing URL: \(socialAccountInfo)")
                            continue
                        }

                        socialAccounts.append(SocialAccount(handle: handle, urlString: urlString))
                    }
                }
            }

            var films = [Film]()
            if let filmInfoList = result[Keys.Filmography] as? NSArray {
                for filmInfo in filmInfoList {
                    if let filmInfo = filmInfo as? NSDictionary {
                        guard let id = (filmInfo[Keys.ProjectID] as? NSNumber)?.stringValue else {
                            print("Ignoring film object with missing ID: \(filmInfo)")
                            continue
                        }

                        guard let title = filmInfo[Keys.ProjectName] as? String else {
                            print("Ignoring film object with missing title: \(filmInfo)")
                            continue
                        }

                        var imageURL: URL?
                        if let posterImageURLString = ((filmInfo[Keys.Posters] as? NSArray)?.firstObject as? NSDictionary)?[Keys.LargeURL] as? String {
                            imageURL = URL(string: posterImageURLString)
                        }

                        films.append(Film(id: id, title: title, imageURL: imageURL))
                    }
                }
            }

            completionHandler(result[Keys.ShortBio] as? String, socialAccounts, films)
        }, errorBlock: { (error) in
            print("Error fetching talent details for ID \(id): \(error?.localizedDescription ?? "Unknown error")")
            completionHandler(nil, nil, [])
        })
    }

}
