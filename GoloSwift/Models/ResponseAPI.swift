//
//  ResponseAPI.swift
//  GoloSwift
//
//  Created by msm72 on 13.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

// MARK: -
public struct ResponseAPIResultError: Decodable {
    // MARK: - In work
    public let error: ResponseAPIError
    public let id: Int64
    public let jsonrpc: String
}

// MARK: -
public struct ResponseAPIError: Decodable {
    // MARK: - In work
    public let code: Int64
    public let message: String
}


// MARK: -
public struct ResponseAPIFeedResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: [ResponseAPIFeed]?
    public let error: ResponseAPIError?
}

// MARK: -
public struct ResponseAPIFeed: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let body: String
    public let title: String
    public let author: String
    public let category: String
    public let permlink: String
    public let allow_votes: Bool
    public let allow_replies: Bool
    public let json_metadata: String?
    public let active_votes: [ResponseAPIActiveVote]
    
    // MARK: - In reserve
    /*
     let abs_rshares: Conflicted
     let active: String
     
     let allow_curation_rewards: Bool
     let author_reputation: Conflicted
     let author_rewards: Int
     //    beneficiaries =             ();       // ???
     let body_length: Int64
     let cashout_time: String                // "2018-04-20T10:19:54"
     let children: Int
     let children_abs_rshares: Conflicted
     let children_rshares2: String
     let created: String                     // "2018-04-13T10:19:54"
     let curator_payout_value: String
     let depth: Int
     let last_payout: String                 // "1970-01-01T00:00:00"
     let last_update: String                 // "2018-04-13T11:03:12"
     let max_accepted_payout: String
     let max_cashout_time: String            // "1969-12-31T23:59:59"
     let mode: String
     let net_rshares: Conflicted
     let net_votes: Int64
     let parent_author: String?
     let parent_permlink: String
     let pending_payout_value: String
     let percent_steem_dollars: Int64
     let promoted: String
     //    "reblogged_by" =             ();      // ???
     //    replies =             ();             // ???
     let reward_weight: Int64
     let root_comment: Int64
     let root_title: String
     let total_payout_value: String
     let total_pending_payout_value: String
     let total_vote_weight: Conflicted
     let url: String
     let vote_rshares: Conflicted
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIActiveVote: Decodable {
    // MARK: - In work
    public let percent: Int16
    public let reputation: Conflicted
    public let rshares: Conflicted
    public let time: String
    public let voter: String
    public let weight: Conflicted
}


/// [Multiple types](https://stackoverflow.com/questions/46759044/swift-structures-handling-multiple-types-for-a-single-property)
public struct Conflicted: Codable {
    public let stringValue: String?
    
    // Where we determine what type the value is
    public init(from decoder: Decoder) throws {
        let container           =   try decoder.singleValueContainer()
        
        do {
            stringValue         =   try container.decode(String.self)
        } catch {
            do {
                stringValue     =   "\(try container.decode(Int64.self))"
            } catch {
                stringValue     =   ""
            }
        }
    }
    
    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    public func encode(to encoder: Encoder) throws {
        var container       =   encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}


// MARK: -
public struct ResponseAPIUserResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: [ResponseAPIUser]?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIUser: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let name: String
    public let post_count: Int64
    public let json_metadata: String?
    public let memo_key: String?
    public let owner: ResponseAPIUserSecretKey?
    public let active: ResponseAPIUserSecretKey?
    public let posting: ResponseAPIUserSecretKey?
    
    
    // MARK: - In reserve
    /*
     let active_challenged: Bool
     let average_bandwidth: Conflicted
     let average_market_bandwidth: Conflicted
     let balance: String
     //    "blog_category" =     {
     //    };
     
     let can_vote: Bool
     let comment_count: Int64
     let created: String                                 // "2017-10-09T21:10:21"
     let curation_rewards: Int64
     let delegated_vesting_shares: String
     //    "guest_bloggers" =     (
     //    );
     let last_account_recovery: String                   // "1970-01-01T00:00:00"
     let last_account_update: String                     // "2017-10-09T21:15:21"
     let last_active_proved: String                      // "1970-01-01T00:00:00"
     let last_bandwidth_update: String                   // "2018-04-18T08:25:03"
     let last_market_bandwidth_update: String            // "2018-04-17T23:14:24"
     let last_owner_proved: String                       // "1970-01-01T00:00:00"
     let last_owner_update: String                       // "2017-10-09T21:15:21"
     let last_post: String                               // "2018-04-17T14:21:51"
     let last_root_post: String                          // "2018-04-17T14:16:42"
     let last_vote_time: String                          // "2018-04-18T08:25:03"
     let lifetime_bandwidth: String
     let lifetime_vote_count: Int64
     let market_history: [String]?
     let memo_key: String
     let mined: Bool
     let new_average_bandwidth: String
     let new_average_market_bandwidth: Conflicted
     let next_vesting_withdrawal: String                 // "1969-12-31T23:59:59"
     let other_history: [String]?
     
     let owner_challenged: Bool
     let post_bandwidth: Int64
     let post_history: [String]?
     
     let posting_rewards: Int64
     let proxied_vsf_votes: [Conflicted]
     let proxy: String?
     let received_vesting_shares: String
     let recovery_account: String
     let reputation: Conflicted
     let reset_account: String?
     let savings_balance: String
     let savings_sbd_balance: String
     let savings_sbd_last_interest_payment: String           // "1970-01-01T00:00:00"
     let savings_sbd_seconds: String
     let savings_sbd_seconds_last_update: String             // "1970-01-01T00:00:00"
     let savings_withdraw_requests: Int64
     let sbd_balance: String
     let sbd_last_interest_payment: String                   // "2018-04-08T09:06:42"
     let sbd_seconds: String
     let sbd_seconds_last_update: String                     // "2018-04-18T07:57:33"
     let tags_usage: [String]?
     let to_withdraw: Conflicted
     let transfer_history: [String]?
     let vesting_balance: String
     let vesting_shares: String
     let vesting_withdraw_rate: String
     let vote_history: [Int64]?
     let voting_power: Int64
     let withdraw_routes: Int64
     let withdrawn: Conflicted
     let witness_votes: [String]?
     let witnesses_voted_for: Int64
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIUserSecretKey: Decodable {
    // MARK: - In work
    public let account_auths: [Conflicted]
    public let weight_threshold: Int64?
    public let key_auths: [[Conflicted]]
}


// MARK: -
public struct ResponseAPIDynamicGlobalPropertiesResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: ResponseAPIDynamicGlobalProperty?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIDynamicGlobalProperty: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let time: String                            // "2018-04-20T19:01:12"
    public let head_block_id: String
    public let head_block_number: Int64
    
    // MARK: - In reserve
    /*
     let current_witness: String
     let total_pow: Int64
     let num_pow_witnesses: Int64
     let virtual_supply: String
     let current_supply: String
     let confidential_supply: String
     let current_sbd_supply: String
     let confidential_sbd_supply: String
     let total_vesting_fund_steem: String
     let total_vesting_shares: String
     let total_reward_fund_steem: String
     let total_reward_shares2: String
     let sbd_interest_rate: Int64
     let sbd_print_rate: Int64
     let average_block_size: Int64
     let maximum_block_size: Int64
     let current_aslot: Int64
     let recent_slots_filled: String
     let participation_count: Int64
     let last_irreversible_block_num: Int64
     let max_virtual_bandwidth: String
     let current_reserve_ratio: Int64
     let vote_regeneration_per_day: Int64
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIVerifyAuthorityResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: Bool?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIAllContentRepliesResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: [ResponseAPIAllContentReply]?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIAllContentReply: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let author: String
    public let permlink: String
    public let category: String
    public let parent_author: String
    public let parent_permlink: String
    public let title: String
    public let body: String
    public let json_metadata: String
    public let last_update: String
    
    // MARK: - In reserve
    /*
     public let created: String
     public let active: String
     public let last_payout: String
     public let depth: Int
     public let children: Int
     public let children_rshares2: String
     public let net_rshares: Int
     public let abs_rshares: Int
     public let vote_rshares: Int
     public let children_abs_rshares: Int
     public let cashout_time: String
     public let max_cashout_time: String
     public let total_vote_weight: Int
     public let reward_weight: Int
     public let total_payout_value: String
     public let curator_payout_value: String
     public let author_rewards: Int
     public let net_votes: Int
     public let mode: String
     public let root_comment: Int64
     public let max_accepted_payout: String
     public let percent_steem_dollars: Int64
     public let allow_replies: Bool
     public let allow_votes: Bool
     public let allow_curation_rewards: Bool
     public let beneficiaries: [String]?
     public let url: String
     public let root_title: String
     public let pending_payout_value: String
     public let total_pending_payout_value: String
     public let active_votes: [String]?
     public let replies: [String]?
     public let author_reputation: String
     public let promoted: String
     public let body_length: Int
     public let reblogged_by: [String]?
     */
    // swiftlint:enable identifier_name
}
