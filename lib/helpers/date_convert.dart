
class DateConverter{

  String convert(List<String> simpleFormatDate){

    //  ¡¡¡IMPORTANT!!!
    //To do that this method work is need put the argument in format like to "2022-22-01"
    //  ¡¡¡IMPORTANT!!!

    String year = simpleFormatDate[0];
    String month = simpleFormatDate[1];
    String day = simpleFormatDate[2];

    return '$day de ${monthText(month)} del $year';
  }

  String monthText(String month){
    switch (month) {
      case '01':
      return 'Enero';

      case '02':{
        return 'Febrero';
      }
      case '03':{
        return 'Marzo';
      }
      case '04':{
        return 'Abril';
      }
      case '05':{
        return 'Mayo';
      }
      case '06':{
        return 'Junio';
      }
      case '07':{
        return 'Julio';
      }
      case '08':{
        return 'Agosto';
      }
      case '09':{
        return 'Septiembre';
      }
      case '10':{
        return 'Octubre';
      }
      case '11':{
        return 'Noviembre';
      }
      case '12':{
        return 'Diciembre';
      }
      default: return 'No disponible';
    }
  }
}