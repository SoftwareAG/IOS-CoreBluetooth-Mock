/*
* Copyright (c) 2020, Nordic Semiconductor
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification,
* are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice, this
*    list of conditions and the following disclaimer in the documentation and/or
*    other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors may
*    be used to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
* IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
* NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import CoreBluetoothMock

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Required for the Storyboard to show up.
    var window: UIWindow?
    
    var mockingEnabled: Bool = false
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // UI Tests can't access app code, so the Blinky mock must be in the app.
        // The "mocking-enabled" argument is set in UITests.
        #if DEBUG
        if CommandLine.arguments.contains("mocking-enabled") {
            mockingEnabled = true
            
            // Setup the CoreBluetoothMock in debug mode. The mock central manager
            // will be used by UI tests.
            if #available(iOS 13.0, *) {
                // Example how the authorization can be set and changed.
                /*
                CBMCentralManagerMock.simulateAuthorization(.notDetermined)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                    CBMCentralManagerMock.simulateAuthorization(.allowedAlways)
                }
                */
                CBMCentralManagerMock.simulateFeaturesSupport = { features in
                    return features.isSubset(of: .extendedScanAndConnect)
                }
            }
            CBMCentralManagerMock.simulateInitialState(.poweredOn)
            CBMCentralManagerMock.simulatePeripherals([blinky, hrm, thingy])

            // Set up initial conditions.
            blinky.simulateProximityChange(.immediate)
            hrm.simulateProximityChange(.near)
            thingy.simulateProximityChange(.far)
            blinky.simulateReset()
        }
        #endif
        
        return true
    }

}

