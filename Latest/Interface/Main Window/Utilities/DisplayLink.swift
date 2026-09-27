//
//  DisplayLink.swift
//
//  Created by Max Langer on 23.05.17.
//  Copyright © 2017 Max Langer. All rights reserved.
//

import Foundation
import QuartzCore
#if os(macOS)
import AppKit
#endif

/// Cross-platform convenience for accessing a DisplayLink.
class DisplayLink: NSObject {

	/// The amount of time the display link should be running. If  set to `nil`, the display link runs indefinitely. 
    private(set) var duration : Double?
	
	/// An optional completion handler called after the display link stopped animating.
    var completionHandler : (() -> ())?
	
	/// The current  animation progress. Only useful if a duration has been set.
	private(set) var progress : Double = 0
    
    private var displayLink : CADisplayLink!
    
	/// Frames used to calculate the animation progress
    private var _currentFrame : Double = 0
    private var _frames : Double = 0
    
	/// The callback called for each animation step.
    private(set) var callback : ((_ progress: Double) -> Void)!
    
	
	// MARK: - Initialization
	
		/// Initializes the display link with the given duration and callback.
		#if os(macOS)
		init(view: NSView, duration: Double?, callback: @escaping ((_ progress: Double) -> Void)) {
	        super.init()
	        
	        self.duration = duration
	        self.callback = callback
	        
			self.displayLink = view.displayLink(
				target: self,
				selector: #selector(DisplayLink.displayTick)
			)
			self.displayLink.add(to: .current, forMode: .common)
		}
		#else
		init(duration: Double?, callback: @escaping ((_ progress: Double) -> Void)) {
			super.init()

			self.duration = duration
			self.callback = callback
			self.displayLink = CADisplayLink(
				target: self,
				selector: #selector(DisplayLink.displayTick)
			)
			self.displayLink.add(to: .current, forMode: .common)
		}
		#endif

	
	// MARK: - Animation
    
    @objc private func displayTick() {
        guard let displayLink = self.displayLink else { return }
        
		if let duration = self.duration {
					let rate = (1 / (displayLink.targetTimestamp - displayLink.timestamp)).rounded()
					self._frames = duration * rate
		}
		
		else {
			self._frames = 1
		}
        
			self._currentFrame += 1
        
		// Forward progress to the observer
		DispatchQueue.main.async {
			self.progress = self._currentFrame / self._frames
			if self.duration != nil, self.progress >= 1 {
                self.completionHandler?()
				self.stop()
            }
            
			self.callback(self.progress)
        }
	}
    
	
	// MARK: - Actions
	
	/// Starts the display link.
    func start() {
        self._currentFrame = 0
                
        displayLink.isPaused = false
    }
    
	/// Stops the display link.
    func stop() {
        displayLink.isPaused = true
    }
    
	/// Whether the display link is currently running.
    var isRunning : Bool {
        return !displayLink.isPaused
    }
    
}
