using MG.PowerShell.Show.Components;
using MG.PowerShell.Show.Models;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace MG.PowerShell.Show.Forms
{
    internal class DateTimeForm : Form, IDateTimeForm
    {
        DateTimePicker Date { get; }
        DateTimePicker Time { get; }
        DateTimeFormType Type { get; }

        internal DateTimeForm(bool forceTopMost)
            : this("Select a Time", DateTimeFormType.Default, forceTopMost)
        {
        }

        protected DateTimeForm(string text, DateTimeFormType type, bool forceTopMost)
        {
            this.Type = type;

            // Main Form Settings - Default
            this.Font = new Font("Arial", 13f);
            this.Text = text;

            this.ForeColor = Color.White;
            this.BackColor = Color.Black;

            this.Width = 300;
            this.Height = 165;

            Label dpLabel = MakeDatePickerLabel();
            Label tmLabel = MakeTimePickerLabel();

            this.Date = MakeDTPicker();
            this.Time = MakeTMPicker();

            Button okButton = MakeOKButton();

            // Add Controls
            this.AddControls(dpLabel, tmLabel, this.Date, this.Time);

            // Finalize Form
            this.AcceptButton = okButton;
            this.AddControls(okButton);

            this.TopMost = forceTopMost;
        }

        public IPickerResult ShowPicker()
        {
            return this.ShowPicker(DateTimeReturnType.Both);
        }
        public IPickerResult ShowPicker(DateTimeReturnType returnType)
        {
            DialogResult dres = this.ShowDialog();
            return new PickerResult(
                dres == DialogResult.OK,
                this.Type,
                returnType,
                new DateTimeResult(this.Date.Value, this.Time.Value));
        }

        private void AddControls(params Control[] controls)
        {
            if (null == controls || controls.Length == 0)
                return;

            this.Controls.AddRange(controls);
        }

        private static DateTimePicker MakeDTPicker()
        {
            return new DateTimePicker
            {
                Location = new Point(110, 7),
                Width = 150,
                Format = DateTimePickerFormat.Custom,
                CustomFormat = "MM/dd/yyyy"
            };
        }
        private static DateTimePicker MakeTMPicker()
        {
            return new DateTimePicker
            {
                Location = new Point(110, 52),
                Width = 150,
                Format = DateTimePickerFormat.Custom,
                CustomFormat = "hh:mm:ss tt",
                ShowUpDown = true
            };
        }

        private static Label MakeDatePickerLabel()
        {
            return new Label
            {
                Text = "Date",
                Location = new Point(15, 10),
                Height = 22,
                Width = 90
            };
        }
        private static Label MakeTimePickerLabel()
        {
            return new Label
            {
                Text = "Time",
                Location = new Point(15, 55),
                Height = 22,
                Width = 90
            };
        }

        private static Button MakeOKButton()
        {
            return new Button
            {
                Text = "OK",
                Location = new Point(15, 95),
                ForeColor = Color.Black,
                BackColor = Color.White,
                DialogResult = DialogResult.OK
            };
        }
    }
}
