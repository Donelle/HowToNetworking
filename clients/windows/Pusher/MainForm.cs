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

			this.btnRefresh.Click += (o, e) => _refreshRecipients ();

			this.btnSend.Click += (o, e) => {
				try {
					var content = new PusherContent {
						Text = txtNotification.Text,
						Recipients = new PusherRecipient[] { 
							cmbRecipients.SelectedItem as PusherRecipient
						}
					};
					_service.Push (content);
					MessageBox.Show ("Message was sent successfully!");
					txtNotification.Text = String.Empty;
				} catch (Exception ex) {
					MessageBox.Show (this, ex.Message, this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
			};
		}


		void _refreshRecipients ()
		{
			cmbRecipients.Items.Clear ();

			var items =_service.GetRecipients ().ToList ();
			if (items != null && items.Count > 0) {
				items.ForEach (recipient => cmbRecipients.Items.Add (recipient));
				cmbRecipients.SelectedIndex = 0;
			}
		}
	}
}
