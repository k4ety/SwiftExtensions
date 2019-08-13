//
//  Answers.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/19/18.
//

import Foundation
//import Crashlytics

public class AnswersWrapper : NSObject {
  
  /**
   *  Log a Sign Up event to see users signing up for your app in real-time, understand how
   *  many users are signing up with different methods and their success rate signing up.
   *
   *  @param signUpMethodOrNil     The method by which a user logged in, e.g. Twitter or Digits.
   *  @param signUpSucceededOrNil  The ultimate success or failure of the login
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logSignUp(withMethod signUpMethodOrNil: String?, success signUpSucceededOrNil: NSNumber?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logSignUp(withMethod: signUpMethodOrNil, success: signUpSucceededOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log an Log In event to see users logging into your app in real-time, understand how many
   *  users are logging in with different methods and their success rate logging into your app.
   *
   *  @param loginMethodOrNil      The method by which a user logged in, e.g. email, Twitter or Digits.
   *  @param loginSucceededOrNil   The ultimate success or failure of the login
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logLogin(withMethod loginMethodOrNil: String?, success loginSucceededOrNil: NSNumber?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logLogin(withMethod: loginMethodOrNil, success: loginSucceededOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Share event to see users sharing from your app in real-time, letting you
   *  understand what content they're sharing from the type or genre down to the specific id.
   *
   *  @param shareMethodOrNil      The method by which a user shared, e.g. email, Twitter, SMS.
   *  @param contentNameOrNil      The human readable name for this piece of content.
   *  @param contentTypeOrNil      The type of content shared.
   *  @param contentIdOrNil        The unique identifier for this piece of content. Useful for finding the top shared item.
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logShare(withMethod shareMethodOrNil: String?, contentName contentNameOrNil: String?, contentType contentTypeOrNil: String?, contentId contentIdOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logShare(withMethod: shareMethodOrNil, contentName: contentNameOrNil, contentType: contentTypeOrNil, contentId: contentIdOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log an Invite Event to track how users are inviting other users into
   *  your application.
   *
   *  @param inviteMethodOrNil     The method of invitation, e.g. GameCenter, Twitter, email.
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logInvite(withMethod inviteMethodOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logInvite(withMethod: inviteMethodOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Purchase event to see your revenue in real-time, understand how many users are making purchases, see which
   *  items are most popular, and track plenty of other important purchase-related metrics.
   *
   *  @param itemPriceOrNil         The purchased item's price.
   *  @param currencyOrNil          The ISO4217 currency code. Example: USD
   *  @param purchaseSucceededOrNil Was the purchase successful or unsuccessful
   *  @param itemNameOrNil          The human-readable form of the item's name. Example:
   *  @param itemTypeOrNil          The type, or genre of the item. Example: Song
   *  @param itemIdOrNil            The machine-readable, unique item identifier Example: SKU
   *  @param customAttributesOrNil  A dictionary of custom attributes to associate with this purchase.
   */
  public class func logPurchase(withPrice itemPriceOrNil: NSDecimalNumber?, currency currencyOrNil: String?, success purchaseSucceededOrNil: NSNumber?, itemName itemNameOrNil: String?, itemType itemTypeOrNil: String?, itemId itemIdOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logPurchase(withPrice: itemPriceOrNil, currency: currencyOrNil, success: purchaseSucceededOrNil, itemName: itemNameOrNil, itemType: itemTypeOrNil, itemId: itemIdOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Level Start Event to track where users are in your game.
   *
   *  @param levelNameOrNil        The level name
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this level start event.
   */
  public class func logLevelStart(_ levelNameOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logLevelStart(levelNameOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Level End event to track how users are completing levels in your game.
   *
   *  @param levelNameOrNil                 The name of the level completed, E.G. "1" or "Training"
   *  @param scoreOrNil                     The score the user completed the level with.
   *  @param levelCompletedSuccesfullyOrNil A boolean representing whether or not the level was completed successfully.
   *  @param customAttributesOrNil          A dictionary of custom attributes to associate with this event.
   */
  public class func logLevelEnd(_ levelNameOrNil: String?, score scoreOrNil: NSNumber?, success levelCompletedSuccesfullyOrNil: NSNumber?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logLevelEnd(levelNameOrNil, score: scoreOrNil, success: levelCompletedSuccesfullyOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log an Add to Cart event to see users adding items to a shopping cart in real-time, understand how
   *  many users start the purchase flow, see which items are most popular, and track plenty of other important
   *  purchase-related metrics.
   *
   *  @param itemPriceOrNil         The purchased item's price.
   *  @param currencyOrNil          The ISO4217 currency code. Example: USD
   *  @param itemNameOrNil          The human-readable form of the item's name. Example:
   *  @param itemTypeOrNil          The type, or genre of the item. Example: Song
   *  @param itemIdOrNil            The machine-readable, unique item identifier Example: SKU
   *  @param customAttributesOrNil  A dictionary of custom attributes to associate with this event.
   */
  public class func logAddToCart(withPrice itemPriceOrNil: NSDecimalNumber?, currency currencyOrNil: String?, itemName itemNameOrNil: String?, itemType itemTypeOrNil: String?, itemId itemIdOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logAddToCart(withPrice: itemPriceOrNil, currency: currencyOrNil, itemName: itemNameOrNil, itemType: itemTypeOrNil, itemId: itemIdOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Start Checkout event to see users moving through the purchase funnel in real-time, understand how many
   *  users are doing this and how much they're spending per checkout, and see how it related to other important
   *  purchase-related metrics.
   *
   *  @param totalPriceOrNil        The total price of the cart.
   *  @param currencyOrNil          The ISO4217 currency code. Example: USD
   *  @param itemCountOrNil         The number of items in the cart.
   *  @param customAttributesOrNil  A dictionary of custom attributes to associate with this event.
   */
  public class func logStartCheckout(withPrice totalPriceOrNil: NSDecimalNumber?, currency currencyOrNil: String?, itemCount itemCountOrNil: NSNumber?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logStartCheckout(withPrice: totalPriceOrNil, currency: currencyOrNil, itemCount: itemCountOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Rating event to see users rating content within your app in real-time and understand what
   *  content is most engaging, from the type or genre down to the specific id.
   *
   *  @param ratingOrNil           The integer rating given by the user.
   *  @param contentNameOrNil      The human readable name for this piece of content.
   *  @param contentTypeOrNil      The type of content shared.
   *  @param contentIdOrNil        The unique identifier for this piece of content. Useful for finding the top shared item.
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logRating(_ ratingOrNil: NSNumber?, contentName contentNameOrNil: String?, contentType contentTypeOrNil: String?, contentId contentIdOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logRating(ratingOrNil, contentName: contentNameOrNil, contentType: contentTypeOrNil, contentId: contentIdOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Content View event to see users viewing content within your app in real-time and
   *  understand what content is most engaging, from the type or genre down to the specific id.
   *
   *  @param contentNameOrNil      The human readable name for this piece of content.
   *  @param contentTypeOrNil      The type of content shared.
   *  @param contentIdOrNil        The unique identifier for this piece of content. Useful for finding the top shared item.
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logContentView(withName contentNameOrNil: String?, contentType contentTypeOrNil: String?, contentId contentIdOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logContentView(withName: contentNameOrNil, contentType: contentTypeOrNil, contentId: contentIdOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Search event allows you to see users searching within your app in real-time and understand
   *  exactly what they're searching for.
   *
   *  @param queryOrNil            The user's query.
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event.
   */
  public class func logSearch(withQuery queryOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logSearch(withQuery: queryOrNil, customAttributes: customAttributesOrNil)
  }
  
  /**
   *  Log a Custom Event to see user actions that are uniquely important for your app in real-time, to see how often
   *  they're performing these actions with breakdowns by different categories you add. Use a human-readable name for
   *  the name of the event, since this is how the event will appear in Answers.
   *
   *  @param eventName             The human-readable name for the event.
   *  @param customAttributesOrNil A dictionary of custom attributes to associate with this event. Attribute keys
   *                               must be <code>NSString</code> and values must be <code>NSNumber</code> or <code>NSString</code>.
   *  @discussion                  How we treat <code>NSNumbers</code>:
   *                               We will provide information about the distribution of values over time.
   *
   *                               How we treat <code>NSStrings</code>:
   *                               NSStrings are used as categorical data, allowing comparison across different category values.
   *                               Strings are limited to a maximum length of 100 characters, attributes over this length will be
   *                               truncated.
   *
   *                               When tracking the Tweet views to better understand user engagement, sending the tweet's length
   *                               and the type of media present in the tweet allows you to track how tweet length and the type of media influence
   *                               engagement.
   */
  public class func logCustomEvent(withName eventName: String, customAttributes customAttributesOrNil: [String : Any]? = nil) {
    Answers.logCustomEvent(withName: eventName, customAttributes: customAttributesOrNil)
  }
}
