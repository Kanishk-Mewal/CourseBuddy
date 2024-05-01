Map<String, List<String>> parseCourseContent(String content) {
  List<String> chapters = content.split("###").sublist(1);
  Map<String, List<String>> courseDict = {};

  for (var chapter in chapters) {
    List<String> lines = chapter.trim().split("\n");
    String chapterName = lines[0].trim();
    List<String> topics = [];

    for (var line in lines.sublist(1)) {
      if (line.startsWith("-")) {
        topics.add(line.split("-")[1].trim());
      } else {
        topics.add(line.trim());
      }
    }

    courseDict[chapterName] = topics;
  }

  return courseDict;
}
