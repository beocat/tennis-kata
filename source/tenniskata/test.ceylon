import ceylon.test {
    test,
    assertEquals
}


"If current score is of PointsData and winner does not get forty. Increment Point and return new PointsData"
test
void scoreWhenPointsDataToPointsDataTest(){
	value currentScore = PointsData(love, fifteen);
	value newScore = scoreWhenPoints(currentScore, playerOne);
	assert(is PointsData newScore);
	assertEquals(newScore.playerOnePoints, fifteen);
	assertEquals(newScore.playerTwoPoints, fifteen);
}


"If score is of PointsData and winner gets forty. Return FortyData."
test
void scoreWhenPointsDataToFortyTest(){
	value currentScore = PointsData(love, thirty);
	value newScore = scoreWhenPoints(currentScore, playerTwo);
	assert(is FortyData newScore);
	assertEquals(newScore.player, playerTwo);
	assertEquals(newScore.otherPlayerPoints, love);
}

"If score is FortyPoint, and other player get forty, return Deuce"
test
void scoreWhenFortyToDeuceTest(){
	value currentScore = FortyData(playerOne, thirty);
	value newScore = scoreWhenForty(currentScore, playerTwo);
	assert(is Deuce newScore);
}

"If score is FortyPoint, and other player gets love, fifteen or thirty, return FortyPoint"
test
void scoreWhenFortyToFortyTest(){
	value currentScore = FortyData(playerOne, fifteen);
	value newScore = scoreWhenForty(currentScore, playerTwo);
	assert(is FortyData newScore);
	assertEquals(newScore.player, playerOne);
	assertEquals(newScore.otherPlayerPoints, thirty);
}

"If score is FortyPoint, and player wins, return Game to winner"
test
void scoreWhenFortyToGameTest(){
	value currentScore = FortyData(playerOne, thirty);
	value newScore = scoreWhenForty(currentScore, playerOne);
	assert(is Game newScore);
	assertEquals(newScore.player, playerOne);
}

"When scoring in deuce. Winner gets the advantage."
test
void scoreWhenDeuceTest() {
    value advantagePlayerOne = scoreWhenDeuce(Deuce(), playerOne);
    assert(is Advantage advantagePlayerOne);
    assertEquals(advantagePlayerOne.player, playerOne);
}

"If player with advantage score, she wins the game."
test
void gameWhenAdvantagedWinsTest() {
    value gamePlayerOne = scoreWhenAdvantage(Advantage(playerOne), playerOne);
    assert(is Game gamePlayerOne );
    assertEquals(gamePlayerOne.player, playerOne);
}

"If score is advantage, and non-advantaged player wins, its deuce"
test
void deuceWhenNonAdvatangedPlayerWinsTest(){
    value deuce = scoreWhenAdvantage(Advantage(playerOne), playerTwo);
    assert(is Deuce deuce);
}

"If game is won, no scoring will change that"
test
void scoringWhenGameTest(){
    value gameOne = scoreWhenGame(Game(playerOne), playerOne);
    value gameTwo = scoreWhenGame(Game(playerTwo), playerOne);
    assert(is Game gameOne);
    assertEquals(gameOne.player, playerOne);
    assert(is Game gameTwo);
    assertEquals(gameTwo.player, playerTwo);
}

"Just a couple of runs for scoreSeq"
test
void useScoreSeqToPlayGame(){
	value score1 = scoreSeq([playerOne, playerOne]);
	assert(is PointsData score1);
	assert(score1.playerOnePoints == thirty);
	
	value score2 = scoreSeq([playerOne, playerTwo, playerTwo, playerOne, playerOne, playerTwo, playerTwo]);
	assert(is Advantage score2);
	assert(score2.player == playerTwo);
}