// PACKAGE
import 'enum.dart';



// METHOD
String createName (BinEnum bin) {
  switch (bin) {
    case BinEnum.garbage:
      return 'Garbage';

    case BinEnum.organics:
      return 'Organics';

    case BinEnum.recycling:
      return 'Recycling';
  }
}
