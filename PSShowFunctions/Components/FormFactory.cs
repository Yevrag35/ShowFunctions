using System;
using MG.PowerShell.Show.Forms;

namespace MG.PowerShell.Show.Components
{
    public static class FormFactory
    {
        public static IDateTimeForm Create(bool topMost, DateTimeFormType formType)
        {
            switch (formType)
            {
                case DateTimeFormType.Start:
                    return CreateStart(topMost);

                case DateTimeFormType.End:
                    return CreateEnd(topMost);

                default:
                    return CreateDefault(topMost);
            }
        }

        private static IDateTimeForm CreateDefault(bool topMost)
        {
            return new DateTimeForm(topMost);
        }

        private static IDateTimeForm CreateStart(bool topMost)
        {
            return new StartDateTimeForm(topMost);
        }
        private static IDateTimeForm CreateEnd(bool topMost)
        {
            return new EndDateTimeForm(topMost);
        }
    }
}
