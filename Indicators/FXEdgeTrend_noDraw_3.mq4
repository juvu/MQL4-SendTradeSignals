//+------------------------------------------------------------------+
//|                                           FXEdgeTrend_noDraw.mq4 |
//|                                                    Daniel Sinnig |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Daniel Sinnig"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 3

//--- indicator buffers
double trendBuffer[]; //-1.0 = Downtrend, 0.0 = Sideways, 1.0 = Uptrend
double durationBuffer[]; //indicates the trend durationin number of candles
double priceAtTrendChangeBuffer[]; //indicates the price when last trendchange occured

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,trendBuffer);
   SetIndexStyle(0,DRAW_NONE);
   ArraySetAsSeries(trendBuffer,true); 
   
   SetIndexBuffer(1,durationBuffer);
   SetIndexStyle(1,DRAW_NONE);
   ArraySetAsSeries(durationBuffer,true); 
   
   SetIndexBuffer(2,priceAtTrendChangeBuffer);
   SetIndexStyle(2,DRAW_NONE);
   ArraySetAsSeries(priceAtTrendChangeBuffer,true); 
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   
   int pos;
   if(prev_calculated > 1 )
      pos=prev_calculated-1;
   else
      pos=0;
   
   for (int i = 0; i < rates_total; ++i) {
      double ema12C = iMA(NULL,0,12,0,MODE_EMA,PRICE_HIGH,i);
      double ema34H = iMA(NULL,0,34,0,MODE_EMA,PRICE_HIGH,i);
      double ema34L = iMA(NULL,0,34,0,MODE_EMA,PRICE_LOW,i);
      double ema144C = iMA(NULL,0,144,0,MODE_EMA,PRICE_CLOSE,i);
      double ema169C = iMA(NULL,0,169,0,MODE_EMA,PRICE_CLOSE,i);
            
      if ((ema34H < ema169C) && (ema34H < ema144C)) {
         trendBuffer[i] = -1;
      } else           
      if ((ema34L > ema144C) && (ema34L > ema169C)) {
         trendBuffer[i] = 1;
      } else 
         trendBuffer[i] = 0;
   } 
         
         /*
         //calculate how many candles ago the last trend changed occured
         double currentTrend = trendBuffer[0];
         int duration = 0; 
         for (int i = rates_total-1; i>=0; i--) {
            durationBuffer[i] = ++duration; 
            //if (trendBuffer[i] == currentTrend) duration++;
            //else break;
         }
         //durationBuffer[0] = duration;
         return rates_total;
         */
      //}
   /*
   if (prev_calculated == rates_total) {
      double ema12C = iMA(NULL,0,12,0,MODE_EMA,PRICE_HIGH,0);
      double ema34H = iMA(NULL,0,34,0,MODE_EMA,PRICE_HIGH,0);
      double ema34L = iMA(NULL,0,34,0,MODE_EMA,PRICE_LOW,0);
      double ema144C = iMA(NULL,0,144,0,MODE_EMA,PRICE_CLOSE,0);
      double ema169C = iMA(NULL,0,169,0,MODE_EMA,PRICE_CLOSE,0);
            
      if ((ema34H < ema169C) && (ema34H < ema144C)) {
          trendBuffer[0] = -1;
          if (trendBuffer[1] == -1) {
            durationBuffer[0] = durationBuffer[1]+1;
            priceAtTrendChangeBuffer[0] = priceAtTrendChangeBuffer[1];
          }
          else {
            durationBuffer[0]=1;
            priceAtTrendChangeBuffer[0] = Open[0];
         }
          return rates_total;
      }
            
      if ((ema34L > ema144C) && (ema34L > ema169C)) {
          trendBuffer[0] = 1;
          if (trendBuffer[1] == 1) {
            durationBuffer[0] = durationBuffer[1]+1;
            priceAtTrendChangeBuffer[0] = priceAtTrendChangeBuffer[1];
          }
          else {
            durationBuffer[0]=1;
            priceAtTrendChangeBuffer[0] = Open[0];
         }
         return rates_total;
      }
      
      trendBuffer[0] = 0;
      if (trendBuffer[1] == 0) {
         durationBuffer[0] = durationBuffer[1]+1;
         priceAtTrendChangeBuffer[0] = priceAtTrendChangeBuffer[1];
      }
      else {
         durationBuffer[0]=1;
         priceAtTrendChangeBuffer[0] = Open[0];
      }

      return rates_total;
   }
   
   if (prev_calculated != rates_total) {
      double ema12C = iMA(NULL,0,12,0,MODE_EMA,PRICE_HIGH,0);
      double ema34H = iMA(NULL,0,34,0,MODE_EMA,PRICE_HIGH,0);
      double ema34L = iMA(NULL,0,34,0,MODE_EMA,PRICE_LOW,0);
      double ema144C = iMA(NULL,0,144,0,MODE_EMA,PRICE_CLOSE,0);
      double ema169C = iMA(NULL,0,169,0,MODE_EMA,PRICE_CLOSE,0);
            
      if ((ema34H < ema169C) && (ema34H < ema144C)) {
          trendBuffer[0] = -1;
          if (trendBuffer[1] == -1) {
            durationBuffer[0] = durationBuffer[1]+1;
            priceAtTrendChangeBuffer[0] = priceAtTrendChangeBuffer[1];
          }
          else {
            durationBuffer[0]=1;
            priceAtTrendChangeBuffer[0] = Open[0];
         }
          return rates_total;
      }
            
      if ((ema34L > ema144C) && (ema34L > ema169C)) {
          trendBuffer[0] = 1;
          if (trendBuffer[1] == 1) {
            durationBuffer[0] = durationBuffer[1]+1;
            priceAtTrendChangeBuffer[0] = priceAtTrendChangeBuffer[1];
          }
          else {
            durationBuffer[0]=1;
            priceAtTrendChangeBuffer[0] = Open[0];
         }
         return rates_total;
      }
      
      trendBuffer[0] = 0;
      if (trendBuffer[1] == 0) {
         durationBuffer[0] = durationBuffer[1]+1;
         priceAtTrendChangeBuffer[0] = priceAtTrendChangeBuffer[1];
      }
      else {
         durationBuffer[0]=1;
         priceAtTrendChangeBuffer[0] = Open[0];
      }

      return rates_total;
   }
   */
   return rates_total;
  }
//+------------------------------------------------------------------+
