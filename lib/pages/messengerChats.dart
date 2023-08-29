// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';
import 'package:ely_ai_messenger/components/stories/storiesCircle.dart';
import 'package:ely_ai_messenger/components/stories/storiesLists.dart';
// import 'package:image_cache/image_cache.dart';
import 'package:flutter/material.dart';

class MessengerChatsPage extends StatefulWidget {
  const MessengerChatsPage({super.key});

  @override
  State<MessengerChatsPage> createState() => _MessengerChatsPageState();
}

class User {
  final int id;
  final String name;
  final String lastname;
  User(this.id, this.name, this.lastname);
}

class _MessengerChatsPageState extends State<MessengerChatsPage> {
  // //DOCUMENT ID's
  // final List<String> docIds = [];

  // //GET DOCS ID's
  // Future getDocsId() async {
  //   await FirebaseFirestore.instance.collection("users").get().then(
  //         (snapshot) => snapshot.docs.forEach(
  //           (document) {
  //             // print(element.reference.id);
  //             docIds.add(document.reference.id);
  //           },
  //         ),
  //       );
  // }
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  final List<Map<String, dynamic>> _friends = [
    {
      "id": 0,
      "name": "Set",
      "lastname": "Status",
      "avatar":
          "https://raw.githubusercontent.com/elyric10-dev/Files/main/smiley.png",
      "online": false,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": false,
        "conversation": {
          "seen": "",
          "last_message":
              "...................................................................",
          "last_sender": "",
        }
      }
    },
    {
      "id": 1,
      "name": "Sophia",
      "lastname": "Williams",
      "avatar":
          "https://th.bing.com/th/id/OIP.vHzmiuV12LAMHP3Qfs8IcwHaNJ?w=119&h=212&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Sorry, Sophia I'm already taken",
          "last_sender": "You",
        }
      }
    },
    {
      "id": 2,
      "name": "Emma",
      "lastname": "Brown",
      "avatar":
          "https://th.bing.com/th/id/OIP.eoUnpxRqIDjckUrGEosnlwHaEo?w=313&h=195&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": false,
          "last_message": "I think I like you Ely!",
          "last_sender": "Emma"
        }
      }
    },
    {
      "id": 3,
      "name": "Ethan",
      "lastname": "Davis",
      "avatar":
          "https://th.bing.com/th/id/OIP.SXZg1WPhFIm34ray1WvHtQHaEK?w=279&h=180&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Bro Ely, how to be you?",
          "last_sender": "Ethan"
        }
      }
    },
    {
      "id": 4,
      "name": "Mr. Bean",
      "lastname": "Dagreat",
      "avatar":
          "https://th.bing.com/th/id/OIP.GS8Bnoaugb3xNhfhQcaARgAAAA?w=150&h=198&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": false,
          "last_message": "Elyric, Did you already watch my latest episode?",
          "last_sender": "Mr. Bean"
        }
      }
    },
    {
      "id": 5,
      "name": "Benjamin",
      "lastname": "Scott",
      "avatar":
          "https://th.bing.com/th/id/OIP.uZQdLXEgBEvR2OkcVVbBMQHaFj?w=252&h=189&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Bro Ely, Why you're so cool!",
          "last_sender": "Benjamin"
        }
      }
    },
    {
      "id": 6,
      "name": "Mia",
      "lastname": "Lee",
      "avatar":
          "https://th.bing.com/th/id/OIP.WtzARTHgIwRmS9CyUl3fNAHaJI?w=160&h=197&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Elyric, I'm sad :'(.",
          "last_sender": "Mia"
        }
      }
    },
    {
      "id": 7,
      "name": "Ava",
      "lastname": "Hernandez",
      "avatar":
          "https://th.bing.com/th/id/OIP.UXA8yFUr_GjeIyPUaNcSdwHaJ4?w=156&h=202&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": false,
          "last_message": "Ely, Are you free today?",
          "last_sender": "Ava"
        }
      }
    },
    {
      "id": 8,
      "name": "Isabella",
      "lastname": "Rodriguez",
      "avatar":
          "https://th.bing.com/th/id/OIP.jO8_mz9yL5JKHvcgqGMmsQHaII?w=172&h=189&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Sorry Isabella, I don't like you",
          "last_sender": "You"
        }
      }
    },
    {
      "id": 9,
      "name": "William",
      "lastname": "Garcia",
      "avatar":
          "https://th.bing.com/th/id/OIP.Oo6of6eyOyN20jvZyYMeTwAAAA?w=132&h=199&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Bro Ely, Nice game!",
          "last_sender": "William"
        }
      }
    },
    {
      "id": 10,
      "name": "Grace",
      "lastname": "Anderson",
      "avatar":
          "https://th.bing.com/th/id/OIP.kx4PP2AZfFKfNHq0yOMSAAHaNJ?w=115&h=180&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Sorry I'm not free today Grace",
          "last_sender": "You"
        }
      }
    },
    {
      "id": 11,
      "name": "Chloe",
      "lastname": "Wright",
      "avatar":
          "https://th.bing.com/th/id/OIP.TlA1Y45-eYStBF6RXdwclgHaE7?w=286&h=191&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Hello Elyric, Do you have Gcash?",
          "last_sender": "Chloe"
        }
      }
    },
    {
      "id": 12,
      "name": "Olivia",
      "lastname": "Green",
      "avatar":
          "https://th.bing.com/th/id/OIP.4tOr8B6FgPuF4Nzd9ZvNjQHaFx?w=246&h=191&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message":
              "Sir Elyric, I already fixed some of your comments on PR 69",
          "last_sender": "Olivia"
        }
      }
    },
    {
      "id": 13,
      "name": "Emily",
      "lastname": "Hall",
      "avatar":
          "https://th.bing.com/th/id/OIP.B-XsTj4JI8QxtY_ArZksvQHaGy?w=209&h=191&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": false,
          "last_message": "Ely, Do you want me to send some pictures?",
          "last_sender": "Emily"
        }
      }
    },
    {
      "id": 14,
      "name": "Madison",
      "lastname": "Turner",
      "avatar":
          "https://th.bing.com/th/id/OIP.oezIsomGpS19oSfvAg847wHaJQ?w=156&h=197&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Sorry, Maddison I already have a girlfriend",
          "last_sender": "You"
        }
      }
    },
    {
      "id": 15,
      "name": "Amelia",
      "lastname": "Williams",
      "avatar":
          "https://th.bing.com/th/id/OIP.O-IE4LdTy5N6ljgI_FygmgHaHS?w=199&h=197&c=7&r=0&o=5&pid=1.7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message":
              "Please stop flood liking my pictures its so annoying!",
          "last_sender": "You"
        }
      }
    },
    {
      "id": 16,
      "name": "Sophia",
      "lastname": "Lee",
      "avatar":
          "https://i.pinimg.com/736x/00/ec/6b/00ec6b1a19a8dd9dee3949d4f7b09c1b.jpg",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "You're pretty but I don't like you. Sorry Sophia",
          "last_sender": "You"
        }
      }
    },
    {
      "id": 17,
      "name": "Ava",
      "lastname": "Johnson",
      "avatar":
          "https://th.bing.com/th/id/OIP.Yk-kO_Mtiin8PDMxF3ZIXAHaIO?pid=ImgDet&w=202&h=224&c=7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Friennnnny! how was it?",
          "last_sender": "Ava"
        }
      }
    },
    {
      "id": 18,
      "name": "Isabella",
      "lastname": "Patel",
      "avatar":
          "https://th.bing.com/th/id/OIP.W5CHyg7Amux91M2i0zLQigHaHd?pid=ImgDet&w=202&h=203&c=7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Did you see I what I sent to you?",
          "last_sender": "Isabella"
        }
      }
    },
    {
      "id": 19,
      "name": "Sofia",
      "lastname": "Nguyen",
      "avatar":
          "https://th.bing.com/th/id/OIP.zPmGlHAEi1E96h21_YnZgAHaHd?pid=ImgDet&w=202&h=203&c=7",
      "online": true,
      "stories": false,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": false,
          "last_message": "Hi, I think I fall in love with you",
          "last_sender": "Sofia"
        }
      }
    },
    {
      "id": 20,
      "name": "Jean",
      "lastname": "Shen",
      "avatar":
          "https://th.bing.com/th/id/OIP.8E-SBZ9xjj2MOdnQJdTcGQHaIi?pid=ImgDet&w=202&h=232&c=7",
      "online": true,
      "stories": true,
      "chat_with": {
        "chat_with_this_friend": true,
        "conversation": {
          "created_at": "12:00",
          "seen": true,
          "last_message": "Elyric, did you check my PR already?",
          "last_sender": "Jean"
        }
      }
    }
  ];

  final TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                            "https://cdn-icons-png.flaticon.com/512/4254/4254068.png"),
                      ),
                    ),
                  ),
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.edit),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        Expanded(
          child: ListView(
            children: [
              //CHATS
              Column(
                children: [
                  //SEARCH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Colors.blue[800],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  //FRIENDS
                  StreamBuilder(
                    stream: users.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];

                              final String name = documentSnapshot.get('name');
                              final String lastName =
                                  documentSnapshot.get('last_name');

                              final createdAt =
                                  documentSnapshot.get('created_at');

                              return SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: _friends.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return StoriesLists(
                                      childName: _friends[index]["name"],
                                      childLastname: _friends[index]
                                          ["lastname"],
                                      childAvatar: _friends[index]["avatar"],
                                      childStatus: _friends[index]["online"],
                                      childStories: _friends[index]["stories"],
                                      statusNumber: index,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Text('Loading...');
                    },
                  ),

                  // CHATS
                  ..._friends.map((user) {
                    if (user["chat_with"]["chat_with_this_friend"] == true) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 6, bottom: 6, right: 5),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              StoriesCircle(
                                childAvatar: user["avatar"],
                                childStatus: user["online"],
                                childStories: user["stories"],
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user["name"]} ${user["lastname"]}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: user["chat_with"]
                                                  ["conversation"]["seen"]
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        user["chat_with"]["conversation"]
                                                    ["last_message"] !=
                                                null
                                            ? "${user["chat_with"]["conversation"]["last_sender"]}: ${user["chat_with"]["conversation"]["last_message"].length > 33 ? user["chat_with"]["conversation"]["last_message"].substring(0, 34) + "..." : user["chat_with"]["conversation"]["last_message"]} · ${user["chat_with"]["conversation"]["created_at"]} PM"
                                            : "",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: user["chat_with"]
                                                  ["conversation"]["seen"]
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
