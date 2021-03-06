//
//  TealiumVolatileDataModuleTests.swift
//  tealium-swift
//
//  Created by Jason Koo on 11/17/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import XCTest

class TealiumVolatileDataModuleTests: XCTestCase {
    
    var module : TealiumVolatileDataModule?
    
    override func setUp() {
        super.setUp()
        
        module = TealiumVolatileDataModule(delegate: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        module = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMinimumProtocolsReturn() {
        
        let expectation = self.expectation(description: "minimumProtocolsReturned")
        let helper = test_tealium_helper()
        let module = TealiumVolatileDataModule(delegate: nil)
        helper.modulesReturnsMinimumProtocols(module: module) { (success, failingProtocols) in
            
            expectation.fulfill()
            XCTAssertTrue(success, "Not all protocols returned. Failing protocols: \(failingProtocols)")
            
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)

    }
    
    func testVolatileDataKeysAvailable() {
        
        let config = TealiumConfig(account:TealiumTestValue.account,
                                   profile:TealiumTestValue.profile,
                                   environment:TealiumTestValue.environment,
                                   optionalData:[String:Any]() as [String : Any])
        
        module?.enable(TealiumEnableRequest(config: config))
        
        let volatileDataKeysExpected = [
            "tealium_account",
            "tealium_profile",
            "tealium_environment",
            "tealium_library_name",
            "tealium_library_version",
            "tealium_random",
            "tealium_session_id",
            "tealium_timestamp_epoch"
            ]
        
        guard let volatileDataReturned = module?.volatileData.getData() else {
            XCTFail("No volatile data returned from test module: \(String(describing: module))")
            return
        }
        
        let missingKeys = test_tealium_helper.missingKeys(fromDictionary: volatileDataReturned, keys: volatileDataKeysExpected)
        
        XCTAssertTrue(missingKeys.isEmpty, "\n\n Volatile data is missing keys: \(missingKeys)")
    }
    
}
