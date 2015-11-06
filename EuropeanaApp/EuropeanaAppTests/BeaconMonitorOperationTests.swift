//
//  BeaconMonitorOperationTests.swift
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 04/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import UIKit
import XCTest

/*

if you get something like 
ld: warning: directory not found for option '-F/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.0.sdk/Developer/Library/Frameworks'

see https://github.com/Quick/Nimble/issues/166, i solved it with:

cd /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.0.sdk
mkdir -p Developer/Library
cd Developer/Library
ln -s ../../../../Library/Frameworks/ Frameworks

*/

class BeaconMonitorOperationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOperation() {
        let exp = expectationWithDescription("testOperation")
        
        let queue = OperationQueue()
        
        let operation = BeaconMonitorOperation();
        
        let observer = BlockObserver { _, errors in
                exp.fulfill()
            }

        operation.addObserver(observer)
        queue.addOperation(operation)
        
        waitForExpectationsWithTimeout(2.0) { error in
            
        }
        
    }

}
