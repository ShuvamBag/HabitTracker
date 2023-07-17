String Hour(String time)
{
  int initial = 0;
  String hr="";
  int hrs=0;
  if(time.substring(time.length-2,time.length)=="PM"){
    initial=12;
  }
  for(int i=0;i<time.length;i++)
    {
      if(time[i] == ":")
        {
          break;
        }
      else
        {
          hr = hr+time[i];
        }
    }
  hrs = int.parse(hr)+initial;
  hr=hrs.toString();
  if(hr.length==1)
    {
      hr = '0'+ hr;
    }
  return hr;
}

String Minute(String time)
{
  String min="";
  int index=0;
  for(int i =0;i<time.length;i++)
    {
      if(time[i]==":")
        {
          index=i;
          break;
        }
    }
  min=time[index+1]+time[index+2];
  return min;
}