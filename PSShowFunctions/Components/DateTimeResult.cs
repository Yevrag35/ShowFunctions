using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MG.PowerShell.Show.Components
{
    public struct DateTimeResult
    {
        private const string _PATTERN = "{0}, yyyy {1}";

        private DateTime _date;
        private DateTime _time;
        private DateTime _combinedDt;
        private DateTime _combinedUtc;
        private string _combinedStr;

        public DateTime Date => _date;
        public DateTime Time => _time;
        public DateTime UtcValue => _combinedUtc;
        public DateTime Value => _combinedDt;
        public string StringValue => _combinedStr;

        public DateTimeResult(DateTime? date, DateTime? time)
        {
            _date = date.GetValueOrDefault();
            _time = time.GetValueOrDefault();

            _combinedDt = new DateTime(_date.Year, _date.Month, _date.Day, _time.Hour, _time.Minute, _time.Second, DateTimeKind.Local);
            _combinedUtc = _combinedDt.ToUniversalTime();

            var dtFormat = CultureInfo.CurrentUICulture.DateTimeFormat;
            _combinedStr = _combinedDt.ToString(string.Format(_PATTERN, dtFormat.MonthDayPattern, dtFormat.ShortTimePattern));
        }

        public string GetDateString()
        {
            var dtFormat = CultureInfo.CurrentUICulture.DateTimeFormat;
            return _date.ToString(string.Format("{0}, yyyy", dtFormat.MonthDayPattern));
        }
        public string GetTimeString()
        {
            var dtFormat = CultureInfo.CurrentUICulture.DateTimeFormat;
            return _time.ToString(dtFormat.ShortTimePattern);
        }

        #region OPERATORS
        public static implicit operator DateTime(DateTimeResult result)
        {
            return result._combinedDt;
        }



        #endregion
    }
}
