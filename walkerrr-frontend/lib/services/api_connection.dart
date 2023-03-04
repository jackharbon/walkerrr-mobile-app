import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/models/users.dart';

// const baseAPI = 'https://walkerrr-backend.onrender.com';
const baseAPI = 'https://walkerrr-backend.cyclic.app';

Future<void>? postUser(postedEmail, uid, displayname) async {
  final url = Uri.parse('$baseAPI/api/users');
  print('------------ $url --------------');
  await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
          {'email': postedEmail, 'uid': uid, 'displayName': displayname}));
  return;
}

Future<void> deleteUserDB(uid) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  return;
}

Future getUserFromDB(uid) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final user = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  final parsedUser = jsonDecode(user.body)[0];
  return parsedUser;
}

Future getUsers() async {
  final url = Uri.parse('$baseAPI/api/users');
  final users = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  final parsedUsers = jsonDecode(users.body);
  print('--------------- \n $parsedUsers \n ---------------');
  return parsedUsers;
}

Future<void> patchUsername(uid, newUsername) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'displayName': newUsername}));
}

Future<void> patchEmail(uid, newEmail) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'email': newEmail}));
}

Future<void> patchQuestsToDB(uid, newQuest) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentQuests = userObject["quests"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'quests': [...currentQuests, newQuest]
      }));
}

Future<void> patchComplete(uid, currentQuest) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentQuests = userObject["quests"];
  final removeable = [];
  currentQuests.asMap().forEach((index, quest) => {
        if (quest["questTitle"] == currentQuest)
          {quest["questCompleted"] = true, removeable.add(quest)},
      });
  for (var quest in removeable) {
    currentQuests.remove(quest);
  }
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'quests': currentQuests}));
}

Future<void> patchCoins(uid, increment) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentCoins = userObject["coins"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'coins': currentCoins + increment}));
}

Future<void> patchTrophiesToDB(uid, newTrophy) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentTrophies = userObject["trophies"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'trophies': [...currentTrophies, newTrophy]
      }));
}

Future<void> patchArmour(uid, newArmour) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({"equippedArmour": newArmour}));
}
