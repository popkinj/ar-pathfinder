# Accounts Receivable Pathfinder Tool

## Development

### Dependencies
- Node 6.x+
- Git CLI
  
### Running Development Environment
1. Install dependencies
```bash
git clone git@github.com:popkinj/ar-pathfinder.git
cd ar-pathfinder
npm install
npm run dev
```

2. Connect to database
```bash
oc get pods # Find the pod name
oc port-forward pod-name 5432:5432
```

3. Starting servers for backend and frontend
```bash
npm run dev
```

## Deploying

```bash
npm run build
git push
```

## Testing
### Connecting to a Openshift Pod
Log into a shell
```bash
oc get pods
oc rsh podname
```

...or run a command
```bash
oc get pods
oc exec podname command
```

