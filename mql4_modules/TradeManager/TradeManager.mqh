//+------------------------------------------------------------------+
//|                                                      OnTrade.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property strict


#ifndef _LOAD_MODULE_ON_TRADE
#define _LOAD_MODULE_ON_TRADE


#include <mql4_modules\OrderData\OrderData.mqh>


/** Class for reproducing OnTrande in MQL4 */
class TradeManager
{
   private:
      static OrderData positons[];
      
      static bool checkPositions(void);
      static void setPositions(void);
      
   public:
      static void Init(void);
      static void Run(void);
};


/** @var OrderData postions[]  Array to hold ordre information. */
static OrderData TradeManager::positons[] = {};


/**
 * Check the status about open orders.
 *
 * @return bool  Returns false if order status changed, otherwise true.
 */
static bool TradeManager::checkPositions(void)
{
   if(ArraySize(TradeManager::positons) != OrdersTotal()) return(false);
   
   for(int i = OrdersTotal() - 1; i >= 0; i--) {
      if(!OrderSelect(i, SELECT_BY_POS)) return(false);
      
      if(TradeManager::positons[i].ticket     != OrderTicket())      return(false);
      if(TradeManager::positons[i].symbol     != OrderSymbol())      return(false);
      if(TradeManager::positons[i].type       != OrderType())        return(false);
      if(TradeManager::positons[i].lots       != OrderLots())        return(false);
      if(TradeManager::positons[i].open_time  != OrderOpenTime())    return(false);
      if(TradeManager::positons[i].open_price != OrderOpenPrice())   return(false);
      if(TradeManager::positons[i].stoploss   != OrderStopLoss())    return(false);
      if(TradeManager::positons[i].takeprofit != OrderTakeProfit())  return(false);
      if(TradeManager::positons[i].expiration != OrderExpiration())  return(false);
      if(TradeManager::positons[i].comment    != OrderComment())     return(false);
      if(TradeManager::positons[i].magic      != OrderMagicNumber()) return(false);
   }
   
   return(true);
}


/** Register the order information to member variable postions. */
static void TradeManager::setPositions(void)
{
   int size = OrdersTotal();
   ArrayResize(TradeManager::positons, size);
   for(int i = size - 1; i >= 0; i--) {
      if(!OrderSelect(i, SELECT_BY_POS)) {
         Print("ng");
         return;
      }
      TradeManager::positons[i].ticket     = OrderTicket();
      TradeManager::positons[i].symbol     = OrderSymbol();
      TradeManager::positons[i].type       = OrderType();
      TradeManager::positons[i].lots       = OrderLots();
      TradeManager::positons[i].open_time  = OrderOpenTime();
      TradeManager::positons[i].open_price = OrderOpenPrice();
      TradeManager::positons[i].stoploss   = OrderStopLoss();
      TradeManager::positons[i].takeprofit = OrderTakeProfit();
      TradeManager::positons[i].expiration = OrderExpiration();
      TradeManager::positons[i].comment    = OrderComment();
      TradeManager::positons[i].magic      = OrderMagicNumber();
   }
}


/** Initialize the member variable positons */
static void TradeManager::Init(void)
{
   TradeManager::setPositions();
}


/** 
 * Execute OnTrade function when there is a change in order information.
 */
static void TradeManager::Run(void)
{
   if(!TradeManager::checkPositions()) {
      TradeManager::setPositions();
      OnTrade();
   }
}


#endif
