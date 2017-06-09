import Foundation
import Underdark

@objc(NetworkManager)
public class NetworkManager: NetworkCommunicator, ReactNearby {
  fileprivate var type: User.PeerType = User.PeerType.OFFLINE
  
  //  MARK: REACT NEARBY UTILITY PROTOCOOL
  @objc public  func advertise(_ kind: String, appId: String) -> Void {
    if self.type == .BROWSER {
      self.type = .ADVERTISER_BROWSER
      self.initTransport("WIFI-BT", inType: .ADVERTISER_BROWSER, appId: appId)
    } else if self.type == .OFFLINE {
      self.type = .ADVERTISER
      self.initTransport("WIFI-BT", inType: .ADVERTISER, appId: appId)
    }
  }
  
  @objc public  func stopAdvertising(_ appId: String) {
    if self.type == .ADVERTISER_BROWSER {
      self.type = .BROWSER
      self.initTransport("WIFI-BT", inType: .BROWSER, appId: appId)
      return
    }
    self.type = .OFFLINE
    self.stopTransport()
  }
  @objc public  func browse(_ kind: String, appId: String) -> Void {
    if self.type == .ADVERTISER {
      self.type = .ADVERTISER_BROWSER
      self.initTransport("WIFI-BT", inType: .ADVERTISER_BROWSER, appId: appId)
    } else if self.type == .OFFLINE {
      self.type = .BROWSER
      self.initTransport("WIFI-BT", inType: .BROWSER, appId: appId)
    }
  }
  
  @objc public  func stopBrowsing(_ appId: String) {
    if self.type == .ADVERTISER_BROWSER {
      self.type = .ADVERTISER
      self.initTransport("WIFI-BT", inType: .ADVERTISER, appId: appId)
      return
    }
    self.type = .OFFLINE
    self.stopTransport()
  }
  @objc public  func getConnectedPeers(_ callback: RCTResponseSenderBlock) {
    var connectedPeers = [[String: AnyObject]]()
    if self.type == .BROWSER || self.type == .ADVERTISER_BROWSER {
      for user in nearbyUsers {
        if user.connected {
          connectedPeers.append(user.getJSUser(nil))
        }
      }
    }
    callback([connectedPeers])
  }
  @objc public  func getNearbyPeers(_ callback: RCTResponseSenderBlock) {
    var jsUsers = [[String: AnyObject]]()
    for user in nearbyUsers {
      jsUsers.append(user.getJSUser(nil))
    }
    callback([jsUsers])
  }
  @objc open func inviteUser(_ id: String) {
    let user = self.findUser(id)
    if(user != nil) {
      user!.connected = true
      self.inviteUser(user: user!)
    }
  }
  @objc public func acceptInvitation(_ userId: String) {
    let user = self.findUser(userId)
    if(user != nil) {
      user!.connected = true
      self.informAcceptedInvite(user: user!)
    }
  }
  @objc public  func disconnectFromPeer(_ peerId: String) {
    let user = self.findUser(peerId)
    if(user != nil) {
      user!.connected = false
      self.informDisonnected(user: user!)
    }
  }
  @objc public  func sendMessage(_ message: String, userId:String) {
    self.sendMessage(message: message, userId: userId)
  }
  
  override public func supportedEvents() -> [String]! {
    return ["lostUser","detectedUser", "messageReceived", "connectedToUser", "receivedInvitation"]
  }
}
