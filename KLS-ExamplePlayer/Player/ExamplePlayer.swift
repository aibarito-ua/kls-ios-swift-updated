//
//  AodPlayer.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/27.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit
import Foundation

class ExamplePlayer: AbstractView {
    
    internal var avPlayer:AVPlayer = AVPlayer()
    //MARK: Private Delegate
    // 재생할 컨텐츠 주소
    fileprivate var _contentURL : String = ""
    // 재생할 컨텐츠 타입 : VOD, AOD, LIVE
    internal var _contentType : ContentType = .VOD
    // 플레이어 상태
    internal var _playerStatus : PlayerStatus = .NotPrepared
    internal var _duration : TimeInterval = 0.0
    // 플레이어 현재 재생 위치
    internal var _currentTime: TimeInterval = 0.0
    // Player Seek Step
    internal var _seekStep: Double = 5.0
    // 구간 반복 시작 위치
    internal var _startPosition: TimeInterval = -1.0
    // 구간 반복 마지막 위치
    internal var _endPosition: TimeInterval = -1.0
    
    internal var _volume: Float = 0.0
    internal var _playbackRateStep: Float = 0.1
    internal var _playbackRate: Float = 0.0
    
    //북마크
    internal var _bookmarks: [KollusBookmark] = []
    // 영상 포스터 이미지
    // KollusContents 에 포스터 이미지가 있을 경우 지정
    // 없을 경우
    internal var _coverImageURL: String = ""
    
    
    internal var _kollusPlayer: KollusPlayerView?
    internal var _kollusContent: KollusContent?
    internal var _kollusStorage: KollusStorage? {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).kollusStorage
        }
    }
    
    
    
//    private var _topbar: Topbar
    internal var _playControl: PlayControl?
    internal var _indicator: UIActivityIndicatorView!
    internal var _pipController: AVPictureInPictureController!
    
    //getter setter
    public var ContentURL: String  {
        get{
            return _contentURL
        }
        set(value) {
            if _contentURL != "" {
                NSLog("이미 지정된 플레이어 URL은 다시 지정 할수 없습니다.\n %c", _contentURL)
            }
            else {
                _contentURL = value
            }
        }
    }
    public var ContentType : ContentType {
        get { return _contentType }
    }
    public var PlayerStatus : PlayerStatus {
        get { return _playerStatus }
    }
    public var CurrentTime : TimeInterval {
        get { return _currentTime }
    }
    public var Duration : TimeInterval {
        get { return _duration }
    }
    public var PlaybackRate : Float {
        get { return _playbackRate }
    }
    public var SeekStep : Double {
        get{
            return _seekStep
        }
        set(value){
            _seekStep = value
        }
    }
    public var StartPosition: TimeInterval {
        get {
            return _startPosition
        }
    }
    public var EndPosition: TimeInterval {
        get { return _endPosition }
    }
    public var CoverImageURL : String {
        get { return _coverImageURL}
        set(value) {_coverImageURL = value}
    }
    
    //Delegate
    public var delegate: ExamplePlayerDelegate?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    init(frame:CGRect, contentURL: String?){
        super.init(frame: frame)
        self.backgroundColor = .black
        self._contentURL = contentURL ?? ""
        NSLog(_contentURL)
        initPlayer()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    deinit {
        releasePlayer()
    }
    
    
    private func initPlayer() {
        self._kollusPlayer = KollusPlayerView()
        self.addSubview(self._kollusPlayer!)
        self._kollusPlayer?.frame = self.bounds
        self._kollusPlayer?.backgroundColor = .clear
        self._kollusPlayer?.translatesAutoresizingMaskIntoConstraints = false
        self._kollusPlayer?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self._kollusPlayer?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self._kollusPlayer?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self._kollusPlayer?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self._kollusStorage?.delegate = self
        
        self._kollusPlayer?.storage = self._kollusStorage
        self._kollusPlayer?.debug = true
        self._kollusPlayer?.repeatMode = .one
        self._kollusPlayer?.delegate = self
        self._kollusPlayer?.drmDelegate = self
        self._kollusPlayer?.lmsDelegate = self
        self._kollusPlayer?.bookmarkDelegate = self
        self._kollusPlayer?.setNetworkTimeOut(5)
        
        self._playControl = PlayControl()
        self._playControl?.backgroundColor = .clear
        self.addSubview(self._playControl!);
        self._playControl?.translatesAutoresizingMaskIntoConstraints = false
        self._playControl?.leadingAnchor.constraint( equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self._playControl?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self._playControl?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self._playControl?.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self._playControl?.delegate = self
        
        
        self._indicator = UIActivityIndicatorView()
        
        self.addSubview(self._indicator)
        self._indicator.backgroundColor = .clear
        self._indicator.center = self.center
        self._indicator.hidesWhenStopped = true
        self.bringSubviewToFront(self._indicator)
        self._indicator.startAnimating()
        
        do {
            try self.prepare()
        }
        catch {
            NSLog("Init Player Prepare Error %c", error.localizedDescription)
        }
        
        
    }
    
    private func releasePlayer() {
        if self._kollusPlayer != nil {
            do {
                if self._kollusPlayer?.storage == nil {
                    self._kollusPlayer?.storage = self._kollusStorage
                }
                try self._kollusPlayer?.stop()
                self._kollusPlayer?.removeFromSuperview()
            } catch {
                print("Player Release Error: ", error.localizedDescription)
            }
        }
    }
    public func prepare() throws -> Void {
        
        if self._playerStatus != .NotPrepared {
            throw ExamplePlayerError.AlreadyPrepared
        }
        else {
            do {
                self._kollusPlayer?.contentURL = _contentURL
                try self._kollusPlayer?.prepareToPlay(withMode: .PlayerTypeNative)
            } catch {
                self.delegate?.error(error: error)
            }
        }
    }
    public func play() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }
        else {
            do {
                try self._kollusPlayer?.play()
            } catch {
                self.delegate?.error(error: error)
            }
        }
    }
    public func pause() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            do {
                try self._kollusPlayer?.pause()
            } catch {
                self.delegate?.error(error: error)
            }
        }
    }
    public func seek(position: TimeInterval) throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._kollusPlayer?.currentPlaybackTime = position
        }
    }
    public func forward() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._kollusPlayer?.currentPlaybackTime += self._seekStep
        }
    }
    public func rewind() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._kollusPlayer?.currentPlaybackTime -= self._seekStep
        }
    }
    public func setRepeatStart(position: TimeInterval) throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._startPosition = position
        }
    }
    public func setRepeatEnd(position: TimeInterval) throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._endPosition = position
        }
    }
    public func resetRepeat() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._startPosition = -1.0
            self._endPosition = -1.0
        }
    }
    func decreasePlaybackRate() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._kollusPlayer?.currentPlaybackRate = self._playbackRate - _playbackRateStep < -2.0 ? -2.0 : self._playbackRate - self._playbackRateStep
            
        }
    }
    func increasePlaybackRate() throws -> Void {
        if self._playerStatus == .NotPrepared {
            throw ExamplePlayerError.NotPreparedError
        }else {
            self._kollusPlayer?.currentPlaybackRate = self._playbackRate - _playbackRateStep > 2.0 ? 2.0 : self._playbackRate - self._playbackRateStep
            
        }
    }
}
