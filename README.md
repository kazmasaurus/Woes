# Woes
A Swift µframework for conveniently defining and handling things that can go wrong.

_Note: The README is super rough, missing entire sections, and mostly just me rambling._

Dealing with errors kinda sucks, which means we do a crappy job of it. My hope is that making it a little easier, and giving a useful guideline on how to do it can let us do a less crappy job.

At a high level, `Woes` is a way of combining a couple of ideas:

- Defining throwable errors in an `enum` makes for an easy to use, document, and read error API.
- `NSError` is actually super powerful (even if it's API sucks).
- `NSError` is even more powerful if you can just throw it into a `UIAlertController` or `UIAlertView`. (Did you know [`NSAlert(error error: NSError)`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSAlert_Class/index.html#//apple_ref/occ/clm/NSAlert/alertWithError:) is a thing? I want that.)

_If having an `NSError` populate your alert view instead of a controller feels wrong to you, might I suggest [why put error messages or recovery steps in the API instead of the controllers](#why-put-error-messages-or-recovery-steps-in-the-API-instead-of-the-controllers)_

## So what's here?

- [x] The `Woeful` protocol, which provides the rough shell of what an error `enum` should have.
- [x] A handful of helpers to make implementing `Woeful` as easy as possible.
- [ ] Convience initializers on `UIAlertController` and `UIAlertView`
- [x] A good excuse to call your errors `Woeful`

## What does a `Woeful` API look like?

_Note: preliminary example_

```Swift
enum TerribleAPIWoes {
	case BadThingHappened
	case ReallyBadThingHappened(because: String?)
}

extension TerribleAPIWoes: Woeful {

	static let domain = "com.everythingisterrible.API"
	var domain: String { return TerribleAPIWoes.domain }

	var code: Int {
		switch self {
		case .BadThingHappened: return 1
		case .ReallyBadThingHappened: return 2
		}
	}

	var userInfo: UserInfo? {
		switch self {
		case .BadThingHappened: return UserInfo(
			localizedDescription: "A 'Bad Thing' happened",
			localizedRecoverySuggestion: "Do the thing!")
		case .ReallyBadThingHappened(let reason): return UserInfo(
			localizedDescription: "A really 'Bad Thing' happened because \(reason)")
		}
	}
}
```

## Why put error messages or recovery steps in the API instead of the controllers

_TODO: Location manager example_

The controller is still the place that can decide whether or not to display an error, how to display that error, or whether it wants to replace an error or it's messaging with it's own.
