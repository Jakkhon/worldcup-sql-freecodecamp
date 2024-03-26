#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
games_csv_file="games.csv"
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    WINNER_TEAM="$($PSQL "SELECT DISTINCT name FROM teams WHERE '$winner' = teams.name")"
    if [[ -z $WINNER_TEAM ]]
    then
      team_winner="$($PSQL "INSERT INTO teams (name) VALUES('$winner');")"
    fi
    OPPONENT_TEAM="$($PSQL "SELECT DISTINCT name FROM teams WHERE '$opponent' = teams.name")"
    if [[ -z $OPPONENT_TEAM ]]
    then
      team_loser="$($PSQL "INSERT INTO teams (name) VALUES('$opponent');")"
    fi
    team_winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")"
    team_loser_id="$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")"

    # echo "Winner Team Id: $team_winner_id; Loser Team Id: $team_loser_id"
    echo "Year: $year Round: $round Winner: $winner Loser: $opponent Winner Goals $winner_goals Opponent Goals $opponent_goals"
    game_d="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', '$team_winner_id', '$team_loser_id', '$winner_goals', '$opponent_goals')")"
  fi
done < "$games_csv_file"