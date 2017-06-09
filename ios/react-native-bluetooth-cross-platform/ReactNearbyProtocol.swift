import Foundation

//  REACT METHODS TO BRIDGE -> LEVERAGES BASIC ADVERTISER BROWSER FUNCTIONALITY
protocol ReactNearby {
  func browse(_ kind: String, appId: String) -> Void
  func stopBrowsing(_ appId: String)
  func advertise(_ kind: String, appId: String) -> Void
  func stopAdvertising(_ appId: String)
  func getConnectedPeers(_ callback: RCTResponseSenderBlock)
  func getNearbyPeers(_ callback: RCTResponseSenderBlock)
  func inviteUser(_ id: String)
  func acceptInvitation(_ userId: String)
  func disconnectFromPeer(_ peerId: String)
  func sendMessage(_ message: String, userId:String)
}
