using System;


namespace Pusher 
{
	using System.Collections.Generic;
	using System.ComponentModel;
	using System.Data;
	using System.Drawing;
	using System.Linq;
	using System.Text;
	using System.Threading.Tasks;
	using System.Windows.Forms;
	using System.ServiceModel;
	using System.ServiceModel.Description;
	using PusherService;
	using System.IO;
	using System.Drawing.Imaging;

	public partial class MainForm : Form {
		IPusherService _service = null;

		public MainForm ()
		{
			InitializeComponent ();
		
			this.Load += (o, e) => {
				var factory = new ChannelFactory<IPusherService> ("PusherService");
				factory.Endpoint.Behaviors.Add (new WebHttpBehavior ());
				_service = factory.CreateChannel ();
				_refreshRecipients ();
			};

			this.txtNotification.TextChanged += (o, e) => 
				this.btnSend.Enabled =
					!String.IsNullOrEmpty (this.txtNotification.Text) || 
					this.imageBox.Image != null
			;

			this.btnRefresh.Click += (o, e) => _refreshRecipients ();

			this.btnSend.Click += (o, e) => {
				try {
					if (!String.IsNullOrEmpty (txtNotification.Text)) {
						_service.Push (new PusherContent {
							Text = txtNotification.Text,
							Recipients = new PusherRecipient[] { 
								cmbRecipients.SelectedItem as PusherRecipient
							}
						});
						txtNotification.Text = String.Empty;
					}

					if (this.imageBox.Image != null) {
						var thumbNail = this.imageBox.Image.GetThumbnailImage (295, 200, () => false, IntPtr.Zero);
						using (var stream = new MemoryStream ()) {
							thumbNail.Save (stream, ImageFormat.Jpeg);
							stream.Seek (0, SeekOrigin.Begin);

							_service.Push (new PusherContent {
								Image = stream.ToArray (),
								Recipients = new PusherRecipient[] { 
									cmbRecipients.SelectedItem as PusherRecipient
								}
							});
							this.imageBox.Image = null;
						}
					}

					
					MessageBox.Show ("Message was sent successfully!");

				} catch (Exception ex) {
					MessageBox.Show (this, ex.Message, this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
			};

			((Control)this.imageBox).AllowDrop = true;
			this.imageBox.DoubleClick += (o, e) => {
				this.imageBox.Image = null;
				this.lblDragInstruction.Visible = true;
				if (String.IsNullOrEmpty (this.txtNotification.Text))
					this.btnSend.Enabled = false;
			};

			this.imageBox.DragEnter += (o, e) => {
				if (e.Data.GetDataPresent (DataFormats.FileDrop)) {
					e.Effect = DragDropEffects.Copy;
				}
			};

			this.imageBox.DragDrop += (o, e) => {
				var files = (String[])e.Data.GetData (DataFormats.FileDrop);
				if (files != null && files.Length == 1) {
					this.imageBox.Image = Image.FromFile (files[0]);
					this.lblDragInstruction.Visible = false;
					this.btnSend.Enabled = true;
				}
			};
		}


		void _refreshRecipients ()
		{
			cmbRecipients.Items.Clear ();

			try {
				var items = _service.GetRecipients ().ToList ();
				if (items != null && items.Count > 0) {
					items.ForEach (recipient => cmbRecipients.Items.Add (recipient));
					cmbRecipients.SelectedIndex = 0;
				}
			} catch (Exception) {
				// Do nothing because the service is not running
				MessageBox.Show (this, "Appears that the Push service is not running", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
			}
		}
	}
}
