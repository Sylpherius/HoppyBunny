import Foundation
enum Side {
    case Left, Right, None
}

class MainScene: CCNode {
    weak var piecesNode : CCNode!
    var pieces : [Piece] = []
    weak var character: Character!
    var pieceLastSide: Side = .Left
    var pieceIndex : Int = 0
    weak var scoreLabel : CCLabelTTF!
    var gameOver = false
    weak var restartButton: CCButton!
    weak var lifeBar: CCSprite!
    var timeLeft: Float = 5 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float(10)
        }
    }
    var score : Int = 0{
        didSet{
            scoreLabel.string = "\(score)"
        }
    }
    
    override func update(delta: CCTime) {
        if gameOver { return }
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
    func triggerGameOver() {
        gameOver = true
        restartButton.visible = true
    }
    func isGameOver() -> Bool {
        var newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
        return gameOver
    }
    func didLoadFromCCB() {
        for x in 0...9 {
            var piece = CCBReader.load("Piece") as! Piece
            pieceLastSide = piece.setObstacle(pieceLastSide)
            var yPos = piece.contentSizeInPoints.height * CGFloat(x)
            piece.position = CGPoint(x : 0, y : yPos)
            piecesNode.addChild(piece)
            pieces.append(piece)
        }
        userInteractionEnabled = true
    }
    func restart() {
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameOver { return }
        var xTouch = touch.locationInWorld().x
        let halfPoint = CCDirector.sharedDirector().viewSize().width / 2
        if xTouch < halfPoint {
            character.left()
        }
        else {
            character.right()
        }
        if isGameOver() { return }
        stepTower()
    }
    func stepTower() {
        var piece = pieces[pieceIndex]
        
        var yDiff = piece.contentSize.height * 10
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff))
        
        piece.zOrder += 1
        
        pieceLastSide = piece.setObstacle(pieceLastSide)
        
        piecesNode.position = ccpSub(piecesNode.position,
            CGPoint(x: 0, y: piece.contentSize.height))
        
        pieceIndex = (pieceIndex + 1) % 10
        if isGameOver() { return }
        timeLeft = timeLeft + 0.25
        score++
    }
}
