'From Cuis7.5 [latest update: #7342] on 9 July 2025 at 1:15:16 pm'!
'Description '!
!provides: 'MemoryGameV1' 1 7!
SystemOrganization addCategory: #MemoryGameV1!


!classDefinition: #MemoryCard category: #MemoryGameV1!
PluggableButtonMorph subclass: #MemoryCard
	instanceVariableNames: 'cardColor done'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV1'!
!classDefinition: 'MemoryCard class' category: #MemoryGameV1!
MemoryCard class
	instanceVariableNames: ''!

!classDefinition: #MemoryGameWindow category: #MemoryGameV1!
SystemWindow subclass: #MemoryGameWindow
	instanceVariableNames: 'size cards tupleSize statusBar playground playing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV1'!
!classDefinition: 'MemoryGameWindow class' category: #MemoryGameV1!
MemoryGameWindow class
	instanceVariableNames: ''!


!MemoryGameWindow commentStamp: '<historical>' prior: 0!
A memory game based on finding identical squares of the same color.!

!MemoryCard methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 15:39:10'!
defaultColor
	^ Color white! !

!MemoryCard methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 18:38:45'!
initialize
	super initialize.
	done := false! !

!MemoryCard methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 14:48:44'!
cardColor
	"Answer the value of cardColor"

	^ cardColor! !

!MemoryCard methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 14:48:44'!
cardColor: anObject
	"Set the value of cardColor"

	cardColor := anObject! !

!MemoryCard methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 18:40:42'!
setDone
	done := true.! !

!MemoryCard methodsFor: 'testing' stamp: 'hlsf 3/15/2025 18:38:55'!
isDone
	^ done! !

!MemoryCard methodsFor: 'testing' stamp: 'hlsf 3/15/2025 18:21:22'!
isFlipped
	^ color = cardColor ! !

!MemoryCard methodsFor: 'action' stamp: 'hlsf 3/15/2025 18:21:22'!
flip
	color := self isFlipped ifTrue:  [self defaultColor] ifFalse: [cardColor ].
	self redrawNeeded ! !

!MemoryGameWindow methodsFor: 'testing' stamp: 'hlsf 4/10/2025 10:52:04'!
isGameWon
	^ (cards elements select: #isDone) size = (size x * size y)! !

!MemoryGameWindow methodsFor: 'testing' stamp: 'hlsf 3/18/2025 23:42:35'!
isPlayed
	^ playing ! !

!MemoryGameWindow methodsFor: 'testing' stamp: 'hlsf 3/18/2025 23:42:45'!
isStopped
	^ playing not! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 18:52:39'!
adoptWidgetsColor: paneColor
" Does nothing, let the buttons have their own colors "! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 4/10/2025 10:51:16'!
doneCards
	^ cards elements select: #isDone! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 4/10/2025 10:40:18'!
flippedCards
	^ cards elements select: [:aCard | aCard isDone not and: [aCard isFlipped] ]! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/16/2025 17:16:57'!
message: aText
	statusBar contents: aText ;
		redrawNeeded ! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/19/2025 16:32:10'!
undoneCards
	^ cards elements asOrderedCollection 
		removeAll: self doneCards;
		yourself.! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 18:24:23'!
distributeColors
	| colors |
	colors := OrderedCollection new.
	size x * size y / tupleSize timesRepeat: [colors add: Color random].
	tupleSize - 1 timesRepeat: [colors := colors, colors].
	^ colors! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/18/2025 23:42:09'!
initialize
	super initialize.
	size := 4 @ 3.
	tupleSize := 2.
	playing := true.
	playground := LayoutMorph newColumn.
	self installToolbar.
	self addMorph: playground.
	self installCards.
	self installStatusBar ! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/18/2025 23:40:41'!
installCards
	| colors  row |
	playground removeAllMorphs.
	cards := Array2D  newSize: size.
	colors := self distributeColors shuffled .
	1 to: size y do: [:y |
		row := LayoutMorph newRow.
		1 to: size x do: [:x | | card |
			card := MemoryCard model: self action: #flip: actionArgument: x@y.
			card layoutSpec proportionalWidth: 1; proportionalHeight: 1.
			card cardColor: colors removeFirst.
			row addMorph: card.
			cards at: x@y put: card ].
		playground addMorph: row ]! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'tsl 7/9/2025 13:14:39'!
installStatusBar
	statusBar := TextParagraphMorph new
			padding: 2;
			color: Color transparent;
			borderWidth: 1;
			borderColor: self borderColor twiceLighter ;
			setHeightOnContent.
	self addMorph: statusBar layoutSpec: LayoutSizeSpec new useMorphHeight.
	self message: 'Welcome to ', 'Memory Game' bold! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'tsl 7/9/2025 13:14:32'!
installToolbar
	| toolbar button |
	toolbar := LayoutMorph newRow separation: 2.
	button := PluggableButtonMorph model: self action: #startGame :: 
		enableSelector: #isStopped;
		icon: Theme current playIcon;
		borderWidth: 2;
		borderColor: Color black;
		setBalloonText: 'Play the game';
		morphExtent: 32 asPoint.
	toolbar addMorph: button.
	button := PluggableButtonMorph model: self action: #stopGame :: 
		enableSelector: #isPlayed;
		icon: Theme current stopIcon;
		setBalloonText: 'Stop the game';
		morphExtent: 32 asPoint.
	toolbar addMorph: button.
	self addMorph: toolbar layoutSpec: LayoutSizeSpec new useMorphHeight
! !

!MemoryGameWindow methodsFor: 'updating' stamp: 'hlsf 3/19/2025 16:37:56'!
flip: position
	| flippedCards |
	(cards at: position) flip; lock.	
	
	" Detect if all flipped cards share the same color "
	flippedCards := self flippedCards.
	(flippedCards collect: [:aCard | aCard cardColor]) asSet size = 1 ifFalse: [
		"Give some time for the play to see the color of this card "
		self message: 'Colors do not match!!'.
		self world doOneCycleNow.
		(Delay forSeconds: 1) wait.
		" Color does not match, unflip the flipped card and unlock "
		flippedCards do: [:aCard | aCard flip; unlock].
		^ self].

	flippedCards size = tupleSize ifTrue: [
		" We found a n-tuple!! "
		self message: 'Great!!' bold, ' You find a ', tupleSize asString, '-tuple!!'.
		flippedCards do: #flash.
		flippedCards do: #setDone.
		self isGameWon ifTrue: [
			self message: 'Congatuluation, you finished the game!!' bold red.
			playing := false] ]! !

!MemoryGameWindow methodsFor: 'updating' stamp: 'hlsf 3/19/2025 16:39:39'!
startGame
	self installCards.
	playing := true.
	self message: 'Starting a new game' bold green! !

!MemoryGameWindow methodsFor: 'updating' stamp: 'hlsf 3/19/2025 16:36:36'!
stopGame
	playing := false.
	self message: 'Game over'.
	self undoneCards do: [:aCard |
		aCard flash; flip.
		self world doOneCycleNow]! !
