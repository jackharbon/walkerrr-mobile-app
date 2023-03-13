import 'package:flutter/material.dart';
import 'package:walkerrr/common/single_quest.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/step_provider.dart' as globalSteps;
import 'package:walkerrr/providers/user_provider.dart';
// import 'package:walkerrr/pages/steps_main_page.dart' as SecondPedometer;
import 'package:walkerrr/services/api_connection.dart';

import 'dart:async';
import 'package:pedometer/pedometer.dart';

class QuestList extends StatefulWidget {
  const QuestList({super.key});

  @override
  State<QuestList> createState() => _QuestListState();
}

final currentQuests = userObject["quests"];

findOffset(questTitle) {
  var returnValue = globalSteps.globalSteps;
  currentQuests?.forEach((quest) {
    if (quest['questTitle'] == questTitle) {
      returnValue = quest['questOffset'];
    }
  });
  return returnValue;
}

startTime(questTitle) {
  var returnValue = DateTime.now().toIso8601String();
  var newTime = DateTime.now();
  var finished = false;
  currentQuests?.forEach((quest) {
    if (quest['questTitle'] == questTitle) {
      returnValue = quest['questStart'];
      if (DateTime.parse(returnValue)
              .add(
                const Duration(days: 1),
              )
              .compareTo(newTime) !=
          1) {
        returnValue = DateTime.now().toIso8601String();
        finished = true;
      }
    }
  });
  if (finished == true) {
    patchComplete(userObject['uid'], questTitle);
    getUserFromDB(userObject['uid']);
    return returnValue;
  } else {
    return returnValue;
  }
}

getCurrent(questTitle) {
  var returnValue = globalSteps.globalSteps;
  currentQuests?.forEach((quest) {
    if (quest['questTitle'] == questTitle) {
      if (quest['questCurrent'] > globalSteps.globalSteps) {
        returnValue = quest['questCurrent'] += globalSteps.globalSteps;
      }
    }
  });
  return returnValue;
}

class _QuestListState extends State<QuestList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  bool isStepCountAvailable = true;
  String status = '?', steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    print('----- onStepCount on steps_main_page:\n$event');
    if (mounted)
      setState(() {
        steps = event.steps.toString();
        globalSteps.StepsContext().updateGlobalSteps(event.steps);
      });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('----- onPedestrianStatusChanged on steps_main_page:\n$event.status');
    setState(() {
      status = event.status;
    });
    print('---- onPedestrianStatusChanged status on steps_main_page:\n$status');
  }

  void onPedestrianStatusError(error) {
    print('---- onPedestrianStatusError on steps_main_page:\n$error');
    setState(() {
      status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    print('---- onStepCountError on steps_main_page:\n$error');
    setState(() {
      // steps = 'Step Count not available';
      isStepCountAvailable = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              GlobalStyleVariables.primaryBackgroundColour,
              GlobalStyleVariables.primaryBackgroundGradientColour,
            ])),
        child: Center(
          child: ListView(
            children: [
              SingleQuest(
                questTitle: "Walk 50 Steps",
                questGoal: 50,
                questOffset: findOffset("Walk 50 Steps"),
                questCurrent: getCurrent("Walk 50 Steps"),
                questStart: startTime("Walk 50 Steps"),
                reward: 400,
                isActive: false,
                completed: false,
              ),
              const Divider(
                color: GlobalStyleVariables.questsDivider,
                thickness: 1.0,
              ),
              SingleQuest(
                questTitle: "Walk 1000 Steps",
                questGoal: 1000,
                questOffset: findOffset("Walk 500 Steps"),
                questCurrent: getCurrent("Walk 500 Steps"),
                questStart: startTime("Walk 500 Steps"),
                reward: 1000,
                isActive: false,
                completed: false,
              ),
              const Divider(
                color: GlobalStyleVariables.questsDivider,
                thickness: 1.0,
              ),
              SingleQuest(
                questTitle: "Walk 2500 Steps",
                questGoal: 2500,
                questOffset: findOffset("Walk 2500 Steps"),
                questCurrent: getCurrent("Walk 2500 Steps"),
                questStart: startTime("Walk 2500 Steps"),
                reward: 1500,
                isActive: false,
                completed: false,
              ),
              const Divider(
                color: GlobalStyleVariables.questsDivider,
                thickness: 1.0,
              ),
              SingleQuest(
                questTitle: "Walk 5000 Steps",
                questGoal: 5000,
                questOffset: findOffset("Walk 5000 Steps"),
                questCurrent: getCurrent("Walk 5000 Steps"),
                questStart: startTime("Walk 5000 Steps"),
                reward: 2500,
                isActive: false,
                completed: false,
              ),
              const Divider(
                color: GlobalStyleVariables.questsDivider,
                thickness: 1.0,
              ),
              SingleQuest(
                questTitle: "Walk 10000 Steps",
                questGoal: 10000,
                questOffset: findOffset("Walk 10000 Steps"),
                questCurrent: getCurrent("Walk 10000 Steps"),
                questStart: startTime("Walk 10000 Steps"),
                reward: 4000,
                isActive: false,
                completed: false,
              ),
              const Divider(
                color: GlobalStyleVariables.questsDivider,
                thickness: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
