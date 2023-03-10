import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';
import "package:walkerrr/providers/step_provider.dart" as globalSteps;

void checkCompletion(progress, currentQuest, reward) {
  if (progress == 1) {
    patchComplete(userObject['uid'], currentQuest);
    patchCoins(userObject['uid'], reward);
  }
  print('---- currentQuest on single_quest:\n$currentQuest');
}

class SingleQuest extends StatefulWidget {
  SingleQuest({
    super.key,
    required this.questTitle,
    required this.questGoal,
    required this.questCurrent,
    required this.questOffset,
    required this.questStart,
    required this.reward,
    required this.completed,
  });

  final String questTitle;
  final int questGoal;
  int questCurrent;
  int questOffset;
  final int reward;
  final String questStart;
  final bool completed;

  @override
  State<SingleQuest> createState() => _SingleQuestState();
}

class _SingleQuestState extends State<SingleQuest> {
  bool isQuestReady = true;
  bool isQuestActive = false;
  bool isQuestFinished = false;
  bool isQuestClaimed = false;
  final currentQuests = userObject["quests"];
  String buttonText = "Start Quest?";
  double progress = 0.0;
  double progressCalc = 0.0;
  var _backgroundColor = GlobalStyleVariables.questsButtonReady;

  @override
  Widget build(BuildContext context) {
    if (currentQuests != null) {
      currentQuests.forEach((quest) => {
            if (quest["questTitle"] == widget.questTitle)
              {
                isQuestActive = true,
              }
          });
    }

    void startQuest() {
      widget.questOffset = widget.questCurrent;
      setState(() {
        final newQuest = {
          "questTitle": widget.questTitle,
          "questGoal": widget.questGoal,
          "questOffset": globalSteps.globalSteps,
          "questCurrent": widget.questCurrent,
          "questStart": widget.questStart,
          "questReward": widget.reward,
          "questCompleted": widget.completed
        };
        patchQuestsToDB(userObject['uid'], newQuest);
        final currentQuests = userObject["quests"];
        userObject["quests"] = [...currentQuests, newQuest];
        isQuestReady = false;
        isQuestActive = true;
        print(
            '---- startQuest - userObject["quests"] on single_quest:\n${userObject["quests"]}');
      });
    }

    void claimQuest() {
      checkCompletion(progress, widget.questTitle, widget.reward);
      setState(() {
        isQuestFinished = false;
        isQuestClaimed = true;
      });
      print(
          '---- claimQuest on single_quest:\n$progress ${widget.questTitle} ${widget.reward}');
    }

    void noAction() {}

    if (isQuestReady) {
      buttonText = "Start Quest?";
      _backgroundColor = GlobalStyleVariables.questsButtonReady;
      progress = 0.0;
      setState(() {
        isQuestReady = true;
        isQuestActive = false;
        isQuestFinished = false;
        isQuestClaimed = false;
      });
    }
    if (isQuestActive) {
      widget.questCurrent = globalSteps.globalSteps;
      buttonText = "Quest Active";
      _backgroundColor = GlobalStyleVariables.questsButtonActive;
      progressCalc =
          (globalSteps.globalSteps - widget.questOffset) / widget.questGoal;
      progress = progressCalc < 1.0 ? progressCalc : 1.0;
      setState(() {
        isQuestReady = false;
        isQuestActive = progress < 1.0 ? true : false;
        isQuestFinished = progress < 1.0 ? false : true;
        isQuestClaimed = false;
      });
    }
    if (isQuestFinished) {
      buttonText = 'Claim ${widget.reward} coins';
      _backgroundColor = GlobalStyleVariables.questsButtonFinished;
      progress = 1.0;
      setState(() {
        isQuestReady = false;
        isQuestActive = false;
        isQuestFinished = true;
        isQuestClaimed = false;
      });
    }
    if (isQuestClaimed) {
      buttonText = "Quest Finished";
      _backgroundColor = GlobalStyleVariables.questsButtonClaimed;
      progress = 1.0;
      setState(() {
        isQuestReady = false;
        isQuestActive = false;
        isQuestFinished = false;
        isQuestClaimed = true;
      });
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.questTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text("Reward: ${widget.reward} coins"),
              ],
            ),
          ),
          // ! text for test to DELETE
          Text(
              'globalSteps:${globalSteps.globalSteps} \nquestCurrent=${widget.questCurrent} questOffset=${widget.questOffset} questGoal=${widget.questGoal}\nprogress: $progress\nprogressCalc: $progressCalc)',
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 80,
              animation: true,
              lineHeight: 26.0,
              backgroundColor: GlobalStyleVariables.questsProgressBarBackground,
              progressColor: GlobalStyleVariables.questsProgressBar,
              barRadius: const Radius.circular(20.0),
              leading: const Icon(Icons.directions_walk_outlined),
              animationDuration: 2000,
              percent: progress,
              center: Text(
                "Progress: ${(progress * 100).toInt()}%",
                style: const TextStyle(
                    color: GlobalStyleVariables.primaryTextLightColour),
              ),
            ),
          ),
          if (isQuestClaimed)
            const Text(
              'Sign Out to update coins',
              style: TextStyle(
                  color: GlobalStyleVariables.questsButtonFinished,
                  fontSize: 16),
            ),
          ElevatedButton(
              onPressed: isQuestReady
                  ? startQuest
                  : isQuestFinished
                      ? claimQuest
                      : noAction,
              style: ElevatedButton.styleFrom(
                  backgroundColor: _backgroundColor,
                  foregroundColor: GlobalStyleVariables.primaryTextLightColour),
              child: Text(buttonText)),
        ],
      ),
    );
  }
}
