class ExperienceType {
  final String name;
  final Experience category;

  const ExperienceType(this.name, this.category);
}

const allExperiencesType = [
  ExperienceType('Cultural Immersion', Experience.culture),
  ExperienceType('Culinary', Experience.culinary),
  ExperienceType('Historical Places', Experience.historical),
  ExperienceType('Leisure', Experience.leisure),
];

enum Experience {
  culture,
  culinary,
  historical,
  leisure,
}