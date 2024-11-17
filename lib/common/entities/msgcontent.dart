/*


class Msgcontent {
  final String? token;
  final String? content;
  final bool type;
  final Timestamp? addtime;

  Msgcontent({
    this.token,
    this.content,
    this.type = false,
    this.addtime,
  });

  factory Msgcontent.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Msgcontent(
      token: data?['token'],
      content: data?['content'],
      type: data?['type'],
      addtime: data?['addtime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (token != null) "token": token,
      if (content != null) "content": content,
      "type": type,
      if (addtime != null) "addtime": addtime,
    };
  }
}*/
