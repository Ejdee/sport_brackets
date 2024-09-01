int numberOfColumns(int participantsNumber) {
  if(numberOfPrerounds(participantsNumber) != -1) {
    int columns = 1;
    while(participantsNumber > 1) {
      participantsNumber = (participantsNumber / 2).ceil();
      columns++;
    }
    return columns;
  } else {
    return -1;
  }
}

int numberOfPrerounds(int participantsNumber) {
  // make list of powers of two to determine the number of prerounds
  List<int> powersOfTwo = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];

  // find the smallest power of two that is greater than the number of participants
  // and return the difference - that is how many participants will advance automatically
  for(int i = 0; i < powersOfTwo.length; i++) {
    if(participantsNumber < powersOfTwo[i]) {
      return participantsNumber - powersOfTwo[i-1];
    } else if (participantsNumber == powersOfTwo[i]) {
      return 0;
    }
  }
  return -1;
}