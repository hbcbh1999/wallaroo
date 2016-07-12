import React from "react"
import { Table } from "react-bootstrap"
import ApplicationsTableRow from "./ApplicationsTableRow"

export default class ApplicationsTable extends React.Component {
	render() {
		const { appConfigs } = this.props;
		const rows =  appConfigs.map(function(appConfig) {
			const appName = appConfig.get("app_name");
			return <ApplicationsTableRow appName={appName} key={appName} />;
		});
		return (
			<Table className="applications">
				<thead>
					<tr>
						<th><h1>Applications</h1></th>
					</tr>
				</thead>
				<tbody className="applications">
					{rows}
				</tbody>
			</Table>
		)
	}
}