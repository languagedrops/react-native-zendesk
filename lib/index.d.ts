interface Config {
    appId: string;
    clientId: string;
    zendeskUrl: string;
}
export declare function initialize(config: Config): void;
export declare function identifyJWT(token: string): void;
export declare function identifyAnonymous(name?: string, email?: string): void;
interface CustomField {
    id: number;
    value: number | string | boolean;
}
interface HelpCenterOptions {
    hideContactSupport?: boolean;
    fields?: CustomField[];
}
export declare function showHelpCenter(options: HelpCenterOptions): void;
interface NewTicketOptions {
    tags?: string[];
    fields?: CustomField[];
}
export declare function showNewTicket(options: NewTicketOptions): void;
export declare function showTickets(options: NewTicketOptions): void;
export {};
