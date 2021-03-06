//+------------------------------------------------------------------+
//|                                                          Env.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+


#ifndef _LOAD_MODULE_ENV
#define _LOAD_MODULE_ENV


/** Include header files */
#include <mql4_modules\Env\defines.mqh>
#include <mql4_modules\SymbolSearch\SymbolSearch.mqh>


/**
 * Load environment file and get value.
 *
 * For bool type, use its own getBoolValue method.
 * Color type needs to be written like clrRed. It is not good to be red.
 * The datetime type needs to be written in yyyy.mm.dd HH: ii: ss format.
 */
class Env
{
   private:
      static string rows[];
      
      static bool loadSymbol(const string symbol);

   public:
      static bool loadEnvFile(const string file);
      
      template <typename T>
      static T get(const string name, T default_value = NULL);
      static bool getBoolValue(const string name, bool default_value = false);
};


/** @var string rows[]  List of environment files. */
static string Env::rows[] = {};


/**
 * Chech if symbol exists in MarketWatch.
 * If symbol does not exist, add it.
 *
 * @param const string symbol  Symbol name.
 * 
 * @return bool  Returns true if succesful, otherwise false.
 */
static bool Env::loadSymbol(const string symbol)
{
   return(StringLen(SymbolSearch::getSymbolInMarket(symbol)) > 0);
}


/**
 * Read environment file.
 *
 * @param const string file  File name.
 * 
 * @return bool  Returns true if successful, otherwise false.
 */
static bool Env::loadEnvFile(const string file)
{
   string value     = "";
   int    str_size  = 0;
   int    row       = 0;
   int    handle    = FileOpen(file, FILE_READ|FILE_TXT);
   string symbol    = "";
   
   if(handle == INVALID_HANDLE) return(false);
   
   while(!FileIsEnding(handle)) {
      /** read the next row */
      str_size = FileReadInteger(handle, INT_VALUE);
      
      /** check the comment */
      value = FileReadString(handle, str_size);
      if(StringSubstr(value, 0, 1) == "#") continue;
      
      /** check '=' */
      if(StringFind(value, "=") == -1) continue;
      
      /** add value to Env::rows */
      ArrayResize(Env::rows, row + 1, 0);
      Env::rows[row] = value;
      row++;
   }
   
   FileClose(handle);
   
   /** Add symbol to MarketWatch. */
   symbol = Env::get<string>("SYMBOL");
   if(StringLen(symbol) > 0 && symbol != _Symbol) {
      if(!Env::loadSymbol(symbol)) return(false);
   }
   
   return(true);
}


/**
 * Get the value corresponding to the key.
 *
 * @param const string name  Key name.
 * @param typename default_value  Initial value when key does not exist.
 *
 * @return typename  Value.
 */
template <typename T>
static T Env::get(const string name, T default_value = NULL)
{
   int    size  = 0;
   string key   = "";
   string value = "";
   
   size = ArraySize(Env::rows);
   for(int i = 0; i < size; i++) {
      key = StringSubstr(Env::rows[i], 0, StringLen(name));
      if(key != name) continue;
      
      if(StringLen(Env::rows[i]) <= StringLen(name) + 1) return(default_value);
      
      value = StringSubstr(Env::rows[i], StringLen(name) + 1);
      return((T)value);
   }
   
   return(default_value);
}


/**
 * Get the value corresponding to the key.
 * Used to get bool tyep value.
 *
 * @param const string name  Key name.
 * @param bool default_value  Initial value when key does not exist.
 *
 * @return bool  Value.
 */
static bool Env::getBoolValue(const string name, bool default_value = false)
{
   int    size  = 0;
   string key   = "";
   string value = "";
   
   size = ArraySize(Env::rows);
   for(int i = 0; i < size; i++) {
      key = StringSubstr(Env::rows[i], 0, StringLen(name));
      if(key != name) continue;
      
      if(StringLen(Env::rows[i]) <= StringLen(name) + 1) return(default_value);
      
      value = StringSubstr(Env::rows[i], StringLen(name) + 1);
      
      if(StringCompare(value,"true",false) == 0 || 
         StringToInteger(value) != 0) {
         return(true);
      }
      return(false);
   }
   
   return(default_value);
}


#endif
