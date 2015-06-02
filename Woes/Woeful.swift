//
//  Woeful.swift
//  Woes
//
//  Created by Zak Remer on 6/2/15.
//  Copyright (c) 2015 Zak Remer. All rights reserved.
//

import Foundation

protocol Woeful {
	var domain: String { get }
	var code: Int { get }
	var userInfo: UserInfo? { get }
}

struct UserInfo {
	let localizedDescription: String?
	let localizedRecoverySuggestion: String?
	let localizedFailureReason: String?

	/// Convenience initializer to ease building partial UserInfos
	///
	///		return UserInfo(
	///			localizedDescription: "Error", 
	///			localizedRecoverySuggestion: "Zhu li, do the thing!")
	init(localizedDescription: String? = nil, localizedRecoverySuggestion: String? = nil, localizedFailureReason: String? = nil) {
		self.localizedDescription = localizedDescription
		self.localizedRecoverySuggestion = localizedRecoverySuggestion
		self.localizedFailureReason = localizedFailureReason
	}

	init(errorDictionary: [NSObject : AnyObject]?) {
		let stringForKey = { key in errorDictionary?[key] as? String }
		self.init(localizedDescription: stringForKey(NSLocalizedDescriptionKey),
			localizedRecoverySuggestion: stringForKey(NSLocalizedRecoverySuggestionErrorKey),
			localizedFailureReason: stringForKey(NSLocalizedFailureReasonErrorKey))
	}

	// Returns an NSDictionary for use in an NSError object.
	var dict: [NSObject : AnyObject]? {
		return [
			NSLocalizedDescriptionKey: localizedDescription ?? NSNull(),
			NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestion ?? NSNull(),
			NSLocalizedFailureReasonErrorKey: localizedFailureReason ?? NSNull(),
		]
	}
}

extension NSError {
	convenience init(woe: Woeful) {
		self.init(domain: woe.domain, code: woe.code, userInfo: woe.userInfo?.dict)
	}
}

extension NSError: Woeful {
	var userInfo: UserInfo? { return nil }
}

