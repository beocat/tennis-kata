abstract class Player() of playerOne | playerTwo {}

object playerOne extends Player() {}
object playerTwo extends Player() {}

abstract class Point() of love | fifteen | thirty {}

object love extends Point() {}
object fifteen extends Point() {}
object thirty extends Point() {}

class PointsData(shared Point playerOnePoints, shared Point playerTwoPoints) {}

class FortyData(shared Player player, shared Point otherPlayerPoints) {}

class Deuce() {}

class Advantage(shared Player player) {}

class Game(shared Player player) {}

alias Score => PointsData|FortyData|Deuce|Advantage|Game;

Score score(Score score, Player winner) {
    Score result;
    switch (score)
    case (is PointsData) {
        result = scoreWhenPoints(score, winner);
    }
    case (is FortyData) {
        result = scoreWhenForty(score, winner);
    }
    case (is Deuce) {
        result = scoreWhenDeuce(score, winner);
    }
    case (is Advantage) {
        result = scoreWhenAdvantage(score, winner);
    }
    case (is Game) {
        result = scoreWhenGame(score, winner);
    }
    return result;
}

Score scoreWhenPoints(PointsData score, Player winner) {
    Score result;
    if (exists winnersPoints = incrementPoint(pointsFor(score, winner))) {
        [Point, Point] newPoints = winner == playerOne then [winnersPoints, score.playerTwoPoints] else [score.playerOnePoints, winnersPoints];
        result = PointsData(*newPoints);
    } else {
        result = FortyData(winner, pointsFor(score, other(winner)));
    }
    return result;
}

Score scoreWhenForty(FortyData score, Player winner) {
    Score result;
    if (score.player == winner) {
        result = Game(winner);
    } else {
        if (exists p = incrementPoint(score.otherPlayerPoints)) {
            result = FortyData(score.player, p);
        } else {
            result = Deuce();
        }
    }
    return result;
}

Score scoreWhenDeuce(Deuce score, Player winner) => Advantage(winner);

Score scoreWhenAdvantage(Advantage score, Player winner)
        => score.player == winner then Game(winner) else Deuce();

Score scoreWhenGame(Game score, Player winner) => score;

Score newGame => PointsData(love, love);

Score scoreSeq([Player+] wins) {
    value startScore = newGame;
    return wins.fold(startScore)(score);
}

Point? incrementPoint(Point current) {
    Point? result;
    switch (current)
    case (love) {
        result = fifteen;
    }
    case (fifteen) {
        result = thirty;
    }
    case (thirty) {
        result = null;
    }
    return result;
}

Point pointsFor(PointsData score, Player player)
        => player == playerOne then score.playerOnePoints else score.playerTwoPoints;

Player other(Player player) => player == playerOne then playerTwo else playerOne;

String pointsToString(Point points) {
    switch (points)
    case (love) {
        return "Love";
    }
    case (fifteen) {
        return "Fifteen";
    }
    case (thirty) {
        return "Thirty";
    }
}