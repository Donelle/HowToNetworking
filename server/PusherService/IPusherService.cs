#region Copyright Information
// IPusherService.cs
#endregion

namespace PusherService 
{
	using System;
	using System.Collections.Generic;
	using System.ServiceModel;
	using System.ServiceModel.Web;
	using System.Runtime.Serialization;
	using System.Net.Sockets;
	using System.Net;
	using System.Threading.Tasks;
	using System.Text;
	

	[DataContract (Namespace = "http://thepottersden.com")]
	public sealed class PusherRecipient {

		#region Properties

		[DataMember (Name = "host")]
		public String Host { get; set; }

		[DataMember (Name = "port")]
		public Int32 Port { get; set; }

		#endregion
	}


	[DataContract (Namespace = "http://thepottersden.com")]
	public sealed class PusherContent {

		[DataMember]
		public String Text { get; set; }

		[DataMember]
		public Byte[] Image { get; set; }

		[DataMember]
		public IEnumerable<PusherRecipient> Recipients { get; set; }
	}


	[ServiceContract (Namespace = "http://thepottersden.com/")]
	public interface IPusherService 
	{
		[OperationContract]
		[WebInvoke (Method = "POST", UriTemplate = "/register", BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json)]
		void Register (PusherRecipient recipient);

		[OperationContract, WebInvoke(Method = "POST")]
		[ServiceKnownType (typeof(PusherRecipient))]
		void Push (PusherContent content);

		[OperationContract]
		IEnumerable<PusherRecipient> GetRecipients ();
	}


	/* The content being sent  */
	internal enum NotificationType { Text = 1, Image = 2, Both = 3 };


	[ServiceBehavior (IncludeExceptionDetailInFaults = true, InstanceContextMode = InstanceContextMode.Single, ConcurrencyMode = ConcurrencyMode.Multiple)]
	public sealed class PusherService : IPusherService {
		#region Fields
		List<PusherRecipient> _recipients = new List<PusherRecipient> ();
		#endregion

		#region IPusherService Members

		void IPusherService.Register (PusherRecipient recipient)
		{
			recipient.Guard ("recipient parameter was null");
			Boolean bFound = false;

			_recipients.ForEach (item => {
				if (item.Host.Equals (recipient.Host)) {
					item.Port = recipient.Port;
					return bFound = true;
				}

				return false;
			});

			if (!bFound) _recipients.Add (recipient);
		}

		void IPusherService.Push (PusherContent content)
		{
			content.Guard ("recipient parameter was null");
			List<Byte[]> bits = new List<Byte[]> ();
			
			if (!String.IsNullOrEmpty (content.Text)) {
				bits.Add (BitConverter.GetBytes ((Int32)NotificationType.Text));
				bits.Add (BitConverter.GetBytes (content.Text.Length));
				bits.Add (Encoding.UTF8.GetBytes (content.Text));
				Parallel.ForEach (content.Recipients, recipient => _SendMessage (recipient, bits.Collapse ()));
			}

			if (!content.Image.IsNullOrDefault () && content.Image.Length > 0) {
				bits.Add (BitConverter.GetBytes ((Int32)NotificationType.Image));
				bits.Add (BitConverter.GetBytes (content.Image.Length));
				bits.Add (content.Image);
				Parallel.ForEach (content.Recipients, recipient => _SendMessage (recipient, bits.Collapse ()));
			}
		}

		IEnumerable<PusherRecipient> IPusherService.GetRecipients ()
		{
			return _recipients;
		}

		#endregion

		#region Methods

		void _SendMessage (PusherRecipient recipient, Byte[] payload)
		{
			using (var socket = new Socket (AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)) {
				socket.SendTimeout = 60000 * 10; /* 10 minutes */
				socket.SendBufferSize = payload.Length;

				try {
					socket.Connect (new IPEndPoint (IPAddress.Parse (recipient.Host), recipient.Port));
#if DEBUG
					PSLogger.Log (PSLogLevel.Info, String.Format ("Sending notification to {0}...", recipient.Host));
#endif
					socket.Send (payload);
#if DEBUG
					PSLogger.Log (PSLogLevel.Info, "Notification Sent!");
#endif
				} catch (Exception ex) {
					// We don't fail the other recipients because we failed.
					PSLogger.LogException (ex);
				} finally {
					if (socket.Connected)
						socket.Close ();
				}
			}
		}

		#endregion

	}
}
