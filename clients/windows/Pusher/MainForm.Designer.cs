namespace Pusher {
	partial class MainForm {
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose (bool disposing)
		{
			if (disposing && (components != null)) {
				components.Dispose ();
			}
			base.Dispose (disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent ()
		{
			this.label1 = new System.Windows.Forms.Label();
			this.cmbRecipients = new System.Windows.Forms.ComboBox();
			this.label2 = new System.Windows.Forms.Label();
			this.txtNotification = new System.Windows.Forms.RichTextBox();
			this.btnSend = new System.Windows.Forms.Button();
			this.btnRefresh = new System.Windows.Forms.Button();
			this.imageBox = new System.Windows.Forms.PictureBox();
			this.lblDragInstruction = new System.Windows.Forms.Label();
			((System.ComponentModel.ISupportInitialize)(this.imageBox)).BeginInit();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(17, 17);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(60, 13);
			this.label1.TabIndex = 0;
			this.label1.Text = "Recipients:";
			// 
			// cmbRecipients
			// 
			this.cmbRecipients.DisplayMember = "Host";
			this.cmbRecipients.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbRecipients.FormattingEnabled = true;
			this.cmbRecipients.Location = new System.Drawing.Point(80, 13);
			this.cmbRecipients.Name = "cmbRecipients";
			this.cmbRecipients.Size = new System.Drawing.Size(130, 21);
			this.cmbRecipients.TabIndex = 1;
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(20, 49);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(212, 13);
			this.label2.TabIndex = 2;
			this.label2.Text = "Enter the notification that you want to send:";
			// 
			// txtNotification
			// 
			this.txtNotification.Location = new System.Drawing.Point(20, 66);
			this.txtNotification.Name = "txtNotification";
			this.txtNotification.Size = new System.Drawing.Size(251, 77);
			this.txtNotification.TabIndex = 3;
			this.txtNotification.Text = "";
			// 
			// btnSend
			// 
			this.btnSend.Enabled = false;
			this.btnSend.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.btnSend.Location = new System.Drawing.Point(80, 277);
			this.btnSend.Name = "btnSend";
			this.btnSend.Size = new System.Drawing.Size(108, 33);
			this.btnSend.TabIndex = 4;
			this.btnSend.Text = "Send Notification";
			this.btnSend.UseVisualStyleBackColor = true;
			// 
			// btnRefresh
			// 
			this.btnRefresh.Location = new System.Drawing.Point(216, 11);
			this.btnRefresh.Name = "btnRefresh";
			this.btnRefresh.Size = new System.Drawing.Size(54, 23);
			this.btnRefresh.TabIndex = 5;
			this.btnRefresh.Text = "Refresh";
			this.btnRefresh.UseVisualStyleBackColor = true;
			// 
			// imageBox
			// 
			this.imageBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.imageBox.Location = new System.Drawing.Point(20, 149);
			this.imageBox.Name = "imageBox";
			this.imageBox.Size = new System.Drawing.Size(250, 122);
			this.imageBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			this.imageBox.TabIndex = 6;
			this.imageBox.TabStop = false;
			// 
			// lblDragInstruction
			// 
			this.lblDragInstruction.AutoSize = true;
			this.lblDragInstruction.Location = new System.Drawing.Point(54, 204);
			this.lblDragInstruction.Name = "lblDragInstruction";
			this.lblDragInstruction.Size = new System.Drawing.Size(178, 13);
			this.lblDragInstruction.TabIndex = 7;
			this.lblDragInstruction.Text = "Drag and Drop jpeg/png image here";
			// 
			// MainForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(288, 322);
			this.Controls.Add(this.lblDragInstruction);
			this.Controls.Add(this.imageBox);
			this.Controls.Add(this.btnRefresh);
			this.Controls.Add(this.btnSend);
			this.Controls.Add(this.txtNotification);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.cmbRecipients);
			this.Controls.Add(this.label1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "MainForm";
			this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
			this.Text = "Notification Sender";
			((System.ComponentModel.ISupportInitialize)(this.imageBox)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox cmbRecipients;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.RichTextBox txtNotification;
		private System.Windows.Forms.Button btnSend;
		private System.Windows.Forms.Button btnRefresh;
		private System.Windows.Forms.PictureBox imageBox;
		private System.Windows.Forms.Label lblDragInstruction;
	}
}

